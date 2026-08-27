<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%@page import="java.sql.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equalsIgnoreCase("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String uID = request.getParameter("newUserID");
    String uName = request.getParameter("newUserName");
    String uPhone = request.getParameter("newUserPhone");
    String uAddress = request.getParameter("newUserAddress");
    String uPass = request.getParameter("newPassword");
    String uRole = request.getParameter("newRole");
    String uGender = request.getParameter("newGender");

    String status = "processing";
    String message = "Processing your request, please wait...";

    if(conn != null) {
        PreparedStatement psCheckID = null;
        PreparedStatement psCheckPhone = null;
        PreparedStatement ps = null;
        ResultSet rsID = null;
        ResultSet rsPhone = null;
        
        try {
            String checkIdSql = "SELECT COUNT(*) FROM Users WHERE LOWER(TRIM(USER_ID)) = LOWER(TRIM(?))";
            psCheckID = conn.prepareStatement(checkIdSql);
            psCheckID.setString(1, uID);
            rsID = psCheckID.executeQuery();
            
            int idCount = 0;
            if(rsID.next()) {
                idCount = rsID.getInt(1);
            }

            int phoneCount = 0;
            if(uPhone != null && !uPhone.trim().isEmpty()) {
                String checkPhoneSql = "SELECT COUNT(*) FROM Users WHERE TRIM(PHONE) = TRIM(?)";
                psCheckPhone = conn.prepareStatement(checkPhoneSql);
                psCheckPhone.setString(1, uPhone);
                rsPhone = psCheckPhone.executeQuery();
                if(rsPhone.next()) {
                    phoneCount = rsPhone.getInt(1);
                }
            }
            
            if(idCount > 0) {
                status = "failed";
                message = "The User ID <b>" + uID + "</b> already exists. Please use a unique User ID.";
            } else if(phoneCount > 0) {
                status = "failed";
                message = "The Phone Number <b>" + uPhone + "</b> is already registered with another user. Please use a unique phone number.";
            } else {
                String sql = "INSERT INTO Users (USER_ID, PASSWORD, USER_ROLE, NAME, PHONE, ADDRESS, GENDER) VALUES (?, ?, ?, ?, ?, ?, ?)";
                ps = conn.prepareStatement(sql);
                
                ps.setString(1, uID);
                ps.setString(2, uPass);
                ps.setString(3, uRole);
                ps.setString(4, uName);
                ps.setString(5, uPhone);
                ps.setString(6, uAddress);
                ps.setString(7, uGender); 
                
                int row = ps.executeUpdate();
                if(row > 0) {
                    status = "success";
                    message = "User registered successfully!";
                } else {
                    status = "failed";
                    message = "Failed to register user. Please try again.";
                }
            }
        } catch(Exception e) {
            status = "failed";
            String fullError = e.getMessage(); 
            if(fullError != null && fullError.contains("ORA-00001")) {
                message = "Duplicate entry detected. The User ID or Phone Number may already exist in the system.";
            } else if(fullError != null && fullError.contains("ORA-")) {
                message = "A database error occurred while registering the user. Please check your inputs.";
            } else {
                message = "Error: " + fullError.replace("'", "");
            }
        } finally {
            if(rsID != null) try { rsID.close(); } catch(Exception e) {}
            if(rsPhone != null) try { rsPhone.close(); } catch(Exception e) {}
            if(psCheckID != null) try { psCheckID.close(); } catch(Exception e) {}
            if(psCheckPhone != null) try { psCheckPhone.close(); } catch(Exception e) {}
            if(ps != null) try { ps.close(); } catch(Exception e) {}
        }
    } else {
        status = "failed";
        message = "Database Connection Failed!";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Processing Request - EduSyncer</title>
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
        }
        .status-card {
            background: rgba(15, 23, 42, 0.75);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 40px;
            width: 100%;
            max-width: 450px;
            text-align: center;
            backdrop-filter: blur(20px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
            position: relative;
        }
        .loader {
            font-size: 3.5rem;
            margin-bottom: 20px;
            display: inline-block;
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        .loader:hover {
            transform: scale(1.1);
        }
        .spin { animation: spin 1.5s infinite linear; color: #00f2fe; }
        .success-icon { color: #10b981; animation: pop 0.5s ease-out; }
        .error-icon { color: #ef4444; animation: pop 0.5s ease-out; }
        
        h3 { font-size: 1.4rem; margin-bottom: 10px; font-weight: 600; letter-spacing: 0.5px; }
        p { color: #94a3b8; font-size: 0.95rem; line-height: 1.5; }

        @keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }
        @keyframes pop { 0% { transform: scale(0.5); opacity: 0; } 100% { transform: scale(1); opacity: 1; } }
    </style>
</head>
<body>

    <div class="status-card" id="statusCard">
        <% if(status.equals("success")) { %>
            <div class="loader success-icon" id="actionIcon" title="Click to return"><i class="fas fa-check-circle"></i></div>
            <h3 style="color: #10b981;">Success!</h3>
            <p><%= message %></p>
        <% } else { %>
            <div class="loader error-icon" id="actionIcon" title="Click to return"><i class="fas fa-times-circle"></i></div>
            <h3 style="color: #ef4444;">Registration Failed</h3>
            <p><%= message %></p>
        <% } %>
        <p style="font-size: 0.8rem; color: #475569; margin-top: 20px;" id="redirectText">Redirecting back to dashboard...</p>
    </div>

    <script>
        let timeLeft = 3;
        let card = document.getElementById("statusCard");
        let redirectText = document.getElementById("redirectText");
        let actionIcon = document.getElementById("actionIcon");
        
        let countdownInterval = setInterval(function() {
            timeLeft--;
            if (timeLeft > 0) {
                redirectText.innerText = "Redirecting in " + timeLeft + " seconds...";
            } else {
                redirectText.innerText = "Redirecting now...";
            }
        }, 1000);

        let redirectTimeout = setTimeout(function() {
            window.location.href = 'adminHome.jsp';
        }, 3000);

        actionIcon.addEventListener("click", function() {
            window.location.href = 'adminHome.jsp';
        });

        card.addEventListener("mouseenter", function() {
            clearTimeout(redirectTimeout);
            clearInterval(countdownInterval);
            redirectText.innerText = "Paused (Move mouse away to resume)";
        });

        card.addEventListener("mouseleave", function() {
            redirectTimeout = setTimeout(function() {
                window.location.href = 'adminHome.jsp';
            }, 1500);
            redirectText.innerText = "Resuming redirection...";
        });
    </script>

</body>
</html>
<%
    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>