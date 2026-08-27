<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ include file="dbConnect.jsp" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equalsIgnoreCase("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String teacherID = request.getParameter("teacherID");
    String newPassword = request.getParameter("password");
    String newName = request.getParameter("name");
    String newPhone = request.getParameter("phone");
    String newAddress = request.getParameter("address");

    boolean isUpdated = false;
    String errorMsg = "";

    if(conn != null && teacherID != null && !teacherID.trim().isEmpty()) {
        PreparedStatement pstCheckPhone = null;
        PreparedStatement pstUser = null;
        ResultSet rsPhone = null;
        
        try {
            conn.setAutoCommit(false); 

            if(newPhone != null && !newPhone.trim().isEmpty()) {
                String checkPhoneSql = "SELECT COUNT(*) FROM Users WHERE TRIM(PHONE) = TRIM(?) AND UPPER(TRIM(USER_ID)) != UPPER(TRIM(?))";
                pstCheckPhone = conn.prepareStatement(checkPhoneSql);
                pstCheckPhone.setString(1, newPhone.trim());
                pstCheckPhone.setString(2, teacherID.trim());
                rsPhone = pstCheckPhone.executeQuery();
                
                int phoneCount = 0;
                if(rsPhone.next()) {
                    phoneCount = rsPhone.getInt(1);
                }

                if(phoneCount > 0) {
                    errorMsg = "The Phone Number <b>" + newPhone.trim() + "</b> is already registered with another user. Please use a unique phone number.";
                }
            }

            if(errorMsg.isEmpty()) {
                String sqlUser = "UPDATE Users SET Password = ?, Name = ?, Phone = ?, Address = ? WHERE UPPER(TRIM(User_ID)) = UPPER(TRIM(?))";
                pstUser = conn.prepareStatement(sqlUser);
                pstUser.setString(1, newPassword != null ? newPassword.trim() : "");
                pstUser.setString(2, newName != null ? newName.trim() : "");
                pstUser.setString(3, newPhone != null ? newPhone.trim() : "");
                pstUser.setString(4, newAddress != null ? newAddress.trim() : "");
                pstUser.setString(5, teacherID.trim());
                
                int userRows = pstUser.executeUpdate();

                if(userRows > 0) {
                    conn.commit(); 
                    isUpdated = true;
                } else {
                    conn.rollback();
                    errorMsg = "Teacher ID '" + teacherID.trim() + "' not found.";
                }
            } else {
                conn.rollback();
            }
        } catch(Exception e) {
            try { conn.rollback(); } catch(SQLException ex) {}
            String fullError = e.getMessage();
            if(fullError != null && fullError.contains("ORA-00001")) {
                errorMsg = "Duplicate entry detected. The Phone Number may already exist in the system.";
            } else {
                errorMsg = "Database Error: " + fullError;
            }
        } finally {
            if(rsPhone != null) { try { rsPhone.close(); } catch(SQLException ex) {} }
            if(pstCheckPhone != null) { try { pstCheckPhone.close(); } catch(SQLException ex) {} }
            if(pstUser != null) { try { pstUser.close(); } catch(SQLException ex) {} }
            try { conn.setAutoCommit(true); } catch(SQLException ex) {}
        }
    } else {
        errorMsg = "Invalid Request: Teacher ID is missing.";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Updating Teacher...</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { background: #020617; color: #fff; display: flex; justify-content: center; align-items: center; height: 100vh; }
        .status-card { 
            background: rgba(30, 41, 59, 0.5); 
            backdrop-filter: blur(20px); 
            padding: 40px; 
            border-radius: 30px; 
            text-align: center; 
            width: 480px; 
            border: 1px solid <%= isUpdated ? "rgba(16, 185, 129, 0.3)" : "rgba(239, 68, 68, 0.3)" %>; 
            position: relative;
        }
        .icon-box { 
            width: 80px; 
            height: 80px; 
            margin: 0 auto 20px; 
            border-radius: 50%; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            font-size: 2.5rem; 
            color: <%= isUpdated ? "#10b981" : "#f87171" %>; 
            cursor: pointer;
            transition: transform 0.2s ease;
        }
        .icon-box:hover { transform: scale(1.1); }
        h2 { font-size: 1.4rem; margin-bottom: 10px; font-weight: 600; }
        p { color: #94a3b8; font-size: 0.95rem; line-height: 1.5; }
    </style>
</head>
<body>
    <div class="status-card" id="statusCard">
        <div class="icon-box" id="actionIcon"><i class="fas <%= isUpdated ? "fa-check-circle" : "fa-times-circle" %>"></i></div>
        <% if(isUpdated) { %>
            <h2 style="color: #10b981;">Update Success!</h2>
            <p>Teacher (<b><%= teacherID %></b>) details updated successfully.</p>
        <% } else { %>
            <h2 style="color: #f87171;">Update Failed</h2>
            <p><%= errorMsg %></p>
        <% } %>
        <p style="font-size: 0.8rem; color: #475569; margin-top: 20px;" id="redirectText">Redirecting back...</p>
    </div>

    <script>
        let timeLeft = 2;
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
            window.location.href = "manageTeachers.jsp";
        }, 2000);

        actionIcon.addEventListener("click", function() {
            window.location.href = "manageTeachers.jsp";
        });

        card.addEventListener("mouseenter", function() {
            clearTimeout(redirectTimeout);
            clearInterval(countdownInterval);
            redirectText.innerText = "Paused (Move mouse away to resume)";
        });

        card.addEventListener("mouseleave", function() {
            redirectTimeout = setTimeout(function() {
                window.location.href = "manageTeachers.jsp";
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