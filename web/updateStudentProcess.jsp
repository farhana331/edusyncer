<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ include file="dbConnect.jsp" %>
<%
   
    String studentID = request.getParameter("studentID");
    String studentName = request.getParameter("studentName");
    String classID = request.getParameter("classID");
    String guardianID = request.getParameter("guardianID");
    String bloodGroup = request.getParameter("bloodGroup"); 

    boolean isSuccess = false;
    String errorMsg = "";

    if(conn != null) {
        try {
            String sql = "UPDATE Students SET Student_Name = ?, Class_ID = ?, Guardian_ID = ?, Blood_Group = ? WHERE Student_ID = ?";
            PreparedStatement pst = conn.prepareStatement(sql);
            
            pst.setString(1, studentName);
            pst.setString(2, classID);
            pst.setString(3, guardianID);
            pst.setString(4, bloodGroup); 
            pst.setString(5, studentID);  
            
            int rows = pst.executeUpdate();
            if(rows > 0) isSuccess = true;
            
            pst.close();
            conn.close();
            
        } catch(Exception e) {
            isSuccess = false;
            errorMsg = e.getMessage();
        }
    } else {
        errorMsg = "Database connection failed!";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Updating Information...</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');
        
        body {
            background: linear-gradient(-45deg, #020617, #0f172a, #1e1b4b, #020617);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            color: #f1f5f9;
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        @keyframes gradientBG { 0% { background-position: 0% 50%; } 50% { background-position: 100% 50%; } 100% { background-position: 0% 50%; } }

        .status-card {
            background: rgba(30, 41, 59, 0.45);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 25px;
            text-align: center;
            max-width: 400px;
            width: 90%;
            border: 1px solid <%= isSuccess ? "rgba(56, 189, 248, 0.3)" : "rgba(239, 68, 68, 0.3)" %>;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
        }

        .icon {
            font-size: 3.5rem;
            margin-bottom: 20px;
            color: <%= isSuccess ? "#38bdf8" : "#f87171" %>;
        }

        .loader-bar {
            height: 4px;
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            margin-top: 25px;
            overflow: hidden;
        }

        .fill {
            height: 100%;
            background: <%= isSuccess ? "#38bdf8" : "#f87171" %>;
            width: 0;
            animation: load 2s linear forwards;
        }

        @keyframes load { from { width: 0; } to { width: 100%; } }
    </style>
</head>
<body>

    <div class="status-card">
        <div class="icon">
            <i class="fas <%= isSuccess ? "fa-user-check" : "fa-circle-xmark" %>"></i>
        </div>
        
        <% if(isSuccess) { %>
            <h2>Success!</h2>
            <p>Information for student <b><%= studentID %></b> has been updated successfully.</p>
        <% } else { %>
            <h2>Update Failed</h2>
            <p style="color: #fca5a5; font-size: 0.85rem;"><%= errorMsg %></p>
        <% } %>

        <div class="loader-bar">
            <div class="fill"></div>
        </div>
        
        <p style="font-size: 0.8rem; margin-top: 15px; color: #94a3b8;">
            <%= isSuccess ? "Redirecting to Manage Students..." : "Returning to previous page..." %>
        </p>
    </div>

    <script>
        setTimeout(function() {
            <% if (isSuccess) { %>
                window.location.href = "manageStudents.jsp";
            <% } else { %>
                window.history.back();
            <% } %>
        }, 2000);
    </script>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>