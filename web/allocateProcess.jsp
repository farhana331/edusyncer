<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    String tID = request.getParameter("teacherID");
    String cID = request.getParameter("classID");
    String sID = request.getParameter("subjectID");

    boolean isSuccess = false;
    String statusTitle = "";
    String statusMsg = "";
    String redirectUrl = "allocateTeacher.jsp";

    if(conn != null) {
        PreparedStatement pst = null;
        try {
           
            String sql = "INSERT INTO Teacher_Allocation (Alloc_ID, Teacher_ID, Class_ID, Subject_ID) " +
                         "VALUES ((SELECT NVL(MAX(Alloc_ID), 0) + 1 FROM Teacher_Allocation), ?, ?, ?)";
                         
            pst = conn.prepareStatement(sql);
            pst.setString(1, tID);
            pst.setString(2, cID);
            pst.setString(3, sID);
            
            int rows = pst.executeUpdate();
            
            if(rows > 0) {
                isSuccess = true;
                statusTitle = "Allocation Done!";
                statusMsg = "Teacher ID <b>" + tID + "</b> has been successfully assigned to Class <b>" + cID + "</b>.";
            }
        } catch(Exception e) {
            isSuccess = false;
            statusTitle = "Allocation Failed!";
            statusMsg = e.getMessage().replace("'", "");
        } finally {
            if(pst != null) { try { pst.close(); } catch(Exception e) {} }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Processing Allocation</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: #020617;
            color: #f1f5f9;
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        .status-card {
            background: rgba(30, 41, 59, 0.4);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 25px;
            text-align: center;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.6);
            border: 1px solid <%= isSuccess ? "rgba(56, 189, 248, 0.3)" : "rgba(239, 68, 68, 0.3)" %>;
            animation: cardSlide 0.6s ease-out;
        }

        @keyframes cardSlide {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .icon-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 20px;
            background: <%= isSuccess ? "rgba(56, 189, 248, 0.1)" : "rgba(239, 68, 68, 0.1)" %>;
            color: <%= isSuccess ? "#38bdf8" : "#f87171" %>;
            border: 2px solid <%= isSuccess ? "rgba(56, 189, 248, 0.2)" : "rgba(239, 68, 68, 0.2)" %>;
        }

        h2 { margin-bottom: 12px; font-weight: 600; color: #fff; }
        p { color: #94a3b8; font-size: 0.95rem; line-height: 1.6; margin-bottom: 25px; }

        .btn-action {
            display: inline-block;
            padding: 12px 25px;
            background: <%= isSuccess ? "#38bdf8" : "#475569" %>;
            color: <%= isSuccess ? "#020617" : "#fff" %>;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.3s;
        }

        .progress-container {
            height: 4px;
            background: rgba(255,255,255,0.05);
            margin-top: 30px;
            border-radius: 10px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: <%= isSuccess ? "#38bdf8" : "#f87171" %>;
            width: 100%;
            animation: cooldown 3s linear forwards;
        }

        @keyframes cooldown { from { width: 100%; } to { width: 0%; } }
    </style>
</head>
<body>

    <div class="status-card">
        <div class="icon-circle">
            <i class="fas <%= isSuccess ? "fa-chalkboard-teacher" : "fa-user-slash" %>"></i>
        </div>
        <h2><%= statusTitle %></h2>
        <p><%= statusMsg %></p>
        
        <a href="<%= redirectUrl %>" class="btn-action">Go Back</a>

        <div class="progress-container">
            <div class="progress-fill"></div>
        </div>
        <div style="margin-top: 15px; font-size: 0.8rem; color: #64748b;">
            Redirecting in 3 seconds...
        </div>
    </div>

    <script>
        setTimeout(function() {
            window.location.href = "<%= redirectUrl %>";
        }, 3000);
    </script>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>