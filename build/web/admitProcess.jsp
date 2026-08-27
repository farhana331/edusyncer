<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%@page import="java.sql.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equalsIgnoreCase("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String sID = request.getParameter("studentID");
    String sPass = request.getParameter("password"); 
    String sName = request.getParameter("studentName");
    String sClass = request.getParameter("classID");
    String gID = request.getParameter("guardianID");
    String sBlood = request.getParameter("bloodGroup");
    
    String sRole = "Student";

    String status = "processing";
    String message = "Processing admission, please wait...";
    String redirectPage = "manageStudents.jsp"; 

    if(conn != null) {
        PreparedStatement psCheck = null;
        PreparedStatement psUser = null;
        PreparedStatement psStudent = null;
        ResultSet rs = null;
        
        try {
            String checkSql = "SELECT COUNT(*) FROM Users WHERE LOWER(TRIM(USER_ID)) = LOWER(TRIM(?))";
            psCheck = conn.prepareStatement(checkSql);
            psCheck.setString(1, sID);
            rs = psCheck.executeQuery();
            
            int count = 0;
            if(rs.next()) {
                count = rs.getInt(1);
            }
            
            if(count > 0) {
                status = "failed";
                message = "The Student ID / User ID <b>" + sID + "</b> already exists. Please use a unique ID.";
                redirectPage = "admitStudent.jsp";
            } else {
                conn.setAutoCommit(false); 

                String sqlUser = "INSERT INTO Users (USER_ID, PASSWORD, USER_ROLE, NAME, PHONE, ADDRESS) VALUES (?, ?, ?, ?, NULL, NULL)";
                psUser = conn.prepareStatement(sqlUser);
                psUser.setString(1, sID);
                psUser.setString(2, sPass);
                psUser.setString(3, sRole);
                psUser.setString(4, sName);
                psUser.executeUpdate();

                String sqlStudent = "INSERT INTO Students (Student_ID, Student_Name, Class_ID, Blood_Group, Guardian_ID) VALUES (?, ?, ?, ?, ?)";
                psStudent = conn.prepareStatement(sqlStudent);
                psStudent.setString(1, sID);
                psStudent.setString(2, sName);
                psStudent.setString(3, sClass);
                psStudent.setString(4, sBlood);
                psStudent.setString(5, gID);
                psStudent.executeUpdate();

                conn.commit(); 
                status = "success";
                message = "Student Admission Completed Successfully!";
            }

        } catch(Exception e) {
            if(conn != null) {
                try { conn.rollback(); } catch(SQLException ex) { ex.printStackTrace(); }
            }
            status = "failed";
            String fullError = e.getMessage();
            if(fullError != null && fullError.contains("ORA-00001")) {
                message = "The Student ID / User ID <b>" + sID + "</b> already exists. Please use a unique ID.";
            } else if(fullError != null && fullError.contains("ORA-")) {
                message = "A database error occurred during admission. Please check your inputs.";
            } else {
                message = "Admission Failed! Error: " + fullError.replace("'", "\\'").replace("\n", " ");
            }
            redirectPage = "admitStudent.jsp"; 
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(psCheck != null) try { psCheck.close(); } catch(Exception e) {}
            if(psUser != null) try { psUser.close(); } catch(Exception e) {}
            if(psStudent != null) try { psStudent.close(); } catch(Exception e) {}
        }
    } else {
        status = "failed";
        message = "Database Connection Failed!";
        redirectPage = "admitStudent.jsp";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Processing Admission - EduSyncer</title>
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
            transform: translateY(0);
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
</head>
<body>

    <div class="status-card" id="statusCard">
        <% if(status.equals("success")) { %>
            <div class="icon-container success-icon"><i class="fas fa-graduation-cap"></i></div>
            <h3 style="background: linear-gradient(to right, #10b981, #34d399); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Admission Successful!</h3>
            <p><%= message %></p>
        <% } else { %>
            <div class="icon-container error-icon"><i class="fas fa-exclamation-triangle"></i></div>
            <h3 style="background: linear-gradient(to right, #ef4444, #f87171); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">Admission Failed</h3>
            <p><%= message %></p>
        <% } %>
        
        <div class="redirect-text" id="redirectText">
            <div class="spinner-small"></div>
            <span>Redirecting in 3 seconds...</span>
        </div>
    </div>

    <script>
        let timeLeft = 3;
        let card = document.getElementById("statusCard");
        let redirectText = document.getElementById("redirectText");
        
        let countdownInterval = setInterval(function() {
            timeLeft--;
            if (timeLeft > 0) {
                redirectText.innerHTML = '<div class="spinner-small"></div><span>Redirecting in ' + timeLeft + ' seconds...</span>';
            } else {
                redirectText.innerHTML = '<div class="spinner-small"></div><span>Redirecting now...</span>';
            }
        }, 1000);

        let redirectTimeout = setTimeout(function() {
            window.location.href = '<%= redirectPage %>';
        }, 3000);

        card.addEventListener("mouseenter", function() {
            clearTimeout(redirectTimeout);
            clearInterval(countdownInterval);
            redirectText.innerHTML = '<span>Paused (Move mouse away to resume)</span>';
        });

        card.addEventListener("mouseleave", function() {
            redirectTimeout = setTimeout(function() {
                window.location.href = '<%= redirectPage %>';
            }, 1500);
            redirectText.innerHTML = '<div class="spinner-small"></div><span>Resuming redirection...</span>';
        });
    </script>

</body>
</html>
<%
    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>