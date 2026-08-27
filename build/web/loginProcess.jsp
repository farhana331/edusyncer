<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ include file="dbConnect.jsp" %>

<%
    String formUserID = request.getParameter("userID");
    String formPassword = request.getParameter("password");
    
    boolean isSuccess = false;
    String userRole = "";
    String redirectPage = "index.jsp";
    String errorMsg = "";

    if(conn != null) {
       
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            String sql = "SELECT User_Role FROM Users WHERE User_ID = ? AND Password = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, formUserID);
            pst.setString(2, formPassword);
            
            rs = pst.executeQuery();
            
            if(rs.next()) {
                isSuccess = true;
                userRole = rs.getString("User_Role");
              
                
                session.setAttribute("loggedUser", formUserID);
                
                if(userRole.equalsIgnoreCase("Admin")) {
                    session.setAttribute("userRole", "Admin"); 
                    redirectPage = "adminHome.jsp";
                } else if(userRole.equalsIgnoreCase("Teacher")) {
                    session.setAttribute("userRole", "Teacher");
                    redirectPage = "teacherHome.jsp";
                } else if(userRole.equalsIgnoreCase("Guardian")) {
                    session.setAttribute("userRole", "Guardian");
                    redirectPage = "guardianHome.jsp";
                } else if(userRole.equalsIgnoreCase("Student")) {
                    session.setAttribute("userRole", "Student");
                    redirectPage = "studentHome.jsp";
                }
                
            } else {
                isSuccess = false;
                errorMsg = "Invalid Credentials. Please try again.";
            }
        } 
        catch(Exception e) {
            isSuccess = false;
            errorMsg = "System Error: " + e.getMessage();
        } 
        
        finally {
            if(rs != null) rs.close();
            if(pst != null) pst.close();
        }
        
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Authenticating...</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');
        
        body {
            background: #020617;
            color: #fff;
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        .login-status-card {
            background: rgba(30, 41, 59, 0.5);
            backdrop-filter: blur(20px);
            padding: 40px;
            border-radius: 30px;
            text-align: center;
            width: 380px;
            border: 1px solid <%= isSuccess ? "rgba(56, 189, 248, 0.3)" : "rgba(239, 68, 68, 0.3)" %>;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .icon-box {
            width: 80px;
            height: 80px;
            margin: 0 auto 20px;
            background: <%= isSuccess ? "rgba(56, 189, 248, 0.1)" : "rgba(239, 68, 68, 0.1)" %>;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 2.5rem;
            color: <%= isSuccess ? "#38bdf8" : "#f87171" %>;
            border: 2px solid <%= isSuccess ? "#38bdf844" : "#f8717144" %>;
        }

        h2 { margin-bottom: 10px; font-weight: 600; letter-spacing: 0.5px; }
        p { color: #94a3b8; font-size: 0.9rem; line-height: 1.5; }

        .progress-container {
            height: 6px;
            background: rgba(255,255,255,0.05);
            border-radius: 10px;
            margin-top: 30px;
            position: relative;
            overflow: hidden;
        }

        .progress-bar {
            height: 100%;
            background: <%= isSuccess ? "linear-gradient(90deg, #38bdf8, #818cf8)" : "#f87171" %>;
            width: 0%;
            animation: grow 1.8s ease-in-out forwards;
        }

        @keyframes grow { to { width: 100%; } }

        .role-tag {
            display: inline-block;
            margin-top: 15px;
            padding: 5px 15px;
            background: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
        }
    </style>
</head>
<body>

    <div class="login-status-card">
        <div class="icon-box">
            <i class="fas <%= isSuccess ? "fa-shield-check" : "fa-shield-exclamation" %>"></i>
        </div>

        <% if(isSuccess) { %>
            <h2>Welcome Back!</h2>
            <p>Access granted for ID: <b><%= formUserID %></b></p>
            <div class="role-tag"><%= userRole %> Dashboard</div>
        <% } else { %>
            <h2>Access Denied</h2>
            <p><%= errorMsg %></p>
        <% } %>

        <div class="progress-container">
            <div class="progress-bar"></div>
        </div>
        
        <p style="font-size: 0.7rem; margin-top: 15px; opacity: 0.6;">
            <%= isSuccess ? "Initializing workspace..." : "Redirecting to login..." %>
        </p>
    </div>

    <script>
        setTimeout(() => {
            window.location.href = "<%= redirectPage %>";
        }, 1800);
    </script>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>