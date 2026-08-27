<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%@page import="java.sql.*" %>
<%
    String classID = request.getParameter("classID");
    String dateMarked = request.getParameter("dateMarked");
    String[] studentIDs = request.getParameterValues("studentIDs");
    String statusResult = "processing";
    String message = "Saving attendance, please wait...";
    String redirectPage = "teacherHome.jsp"; 

    if (conn != null && studentIDs != null) {
        PreparedStatement pst = null;
        try {
            conn.setAutoCommit(false); 

            String sql = "INSERT INTO Attendance (Record_ID, Student_ID, Class_ID, Date_Marked, Status) " +
                         "VALUES ((SELECT NVL(MAX(Record_ID), 0) + 1 FROM Attendance), ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?)";
            
            pst = conn.prepareStatement(sql);

            for (String sID : studentIDs) {
                String status = request.getParameter("status_" + sID);
                
                if(status != null) {
                    pst.setString(1, sID);
                    pst.setString(2, classID);
                    pst.setString(3, dateMarked);
                    pst.setString(4, status);
                    pst.executeUpdate();
                }
            }

            conn.commit();
            statusResult = "success";
            message = "Attendance successfully saved for Class: " + classID + " (" + dateMarked + ")!";

        } catch (Exception e) {
            statusResult = "failed";
            message = "Error saving attendance: " + e.getMessage().replace("'", "\\'").replace("\n", " ");
            redirectPage = "window.history.back();"; 
        } finally {
            if(pst != null) pst.close();
            if(conn != null) conn.close();
        }
    } else {
        statusResult = "failed";
        message = "Invalid Request or No Students Selected!";
        redirectPage = "teacherHome.jsp";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saving Attendance - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Segoe UI", sans-serif; }
        body {
            background: linear-gradient(135deg, #050505 0%, #0b0b20 50%, #1a1a3a 100%);
            color: #fff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }
        .status-card {
            background: rgba(15, 23, 42, 0.75);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 45px 40px;
            width: 100%;
            max-width: 460px;
            text-align: center;
            backdrop-filter: blur(20px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
            animation: fadeInUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }
        .icon-container {
            font-size: 4rem;
            margin-bottom: 25px;
            display: inline-block;
        }
        .success-icon { color: #10b981; animation: popCheck 0.5s cubic-bezier(0.34, 1.56, 0.64, 1); }
        .error-icon { color: #ef4444; animation: popCheck 0.5s cubic-bezier(0.34, 1.56, 0.64, 1); }
        
        h3 { font-size: 1.5rem; margin-bottom: 12px; font-weight: 600; letter-spacing: 0.5px; }
        p { color: #94a3b8; font-size: 0.95rem; line-height: 1.6; word-break: break-word; }
        
        .redirect-text { font-size: 0.8rem; color: #475569; margin-top: 25px; display: flex; align-items: center; justify-content: center; gap: 8px; }
        .spinner-small { width: 14px; height: 14px; border: 2px solid #475569; border-top-color: #00f2fe; border-radius: 50%; animation: spin 1s infinite linear; }

        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        @keyframes popCheck { 0% { transform: scale(0.4); opacity: 0; } 100% { transform: scale(1); opacity: 1; } }
        @keyframes fadeInUp { 0% { transform: translateY(30px); opacity: 0; } 100% { transform: translateY(0); opacity: 1; } }
    </style>
    <script>
        setTimeout(function() {
            <% if(statusResult.equals("success") || !redirectPage.contains("back")) { %>
                window.location.href = '<%= redirectPage %>';
            <% } else { %>
                <%= redirectPage %>
            <% } %>
        }, 2500);
    </script>
</head>
<body>

    <div class="status-card">
        <% if(statusResult.equals("success")) { %>
            <div class="icon-container success-icon"><i class="fas fa-calendar-check"></i></div>
            <h3 style="background: linear-gradient(to right, #10b981, #34d399); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Saved Successfully!</h3>
            <p><%= message %></p>
        <% } else { %>
            <div class="icon-container error-icon"><i class="fas fa-times-circle"></i></div>
            <h3 style="background: linear-gradient(to right, #ef4444, #f87171); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Failed to Save</h3>
            <p><%= message %></p>
        <% } %>
        
        <div class="redirect-text">
            <div class="spinner-small"></div>
            <span>Returning shortly...</span>
        </div>
    </div>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>