<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ include file="dbConnect.jsp" %>
<%
  
    String senderID = (String) session.getAttribute("loggedUser");
    String receiverID = request.getParameter("receiverID");
    String studentID = request.getParameter("studentID"); 
    String subject = request.getParameter("subject");
    String messageBody = request.getParameter("messageBody");

    if (senderID == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    boolean isSuccess = false;
    String errorTrace = "";

    if (conn != null) {
        
        PreparedStatement pst = null;
        
        try {
           
            String sql = "INSERT INTO Messages (MESSAGE_ID, SENDER_ID, RECEIVER_ID, RELATED_STUDENT, SUBJECT, MESSAGE_BODY, SEND_DATE, STATUS) " +
                         "VALUES ((SELECT NVL(MAX(MESSAGE_ID), 0) + 1 FROM Messages), ?, ?, ?, ?, ?, SYSDATE, 'Unread')";
            
            pst = conn.prepareStatement(sql);
            pst.setString(1, senderID);
            pst.setString(2, receiverID);
            pst.setString(3, studentID);
            pst.setString(4, subject);
            pst.setString(5, messageBody);
            
            int rows = pst.executeUpdate();
            if (rows > 0) {
                isSuccess = true;
            }
        } catch (Exception e) {
            isSuccess = false;
            errorTrace = e.getMessage();
        }
      
        finally {
            if (pst != null) pst.close();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Processing...</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');
        body {
            background: #020617;
            color: #f1f5f9;
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .status-card {
            background: rgba(30, 41, 59, 0.5);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 25px;
            text-align: center;
            max-width: 400px;
            width: 90%;
            border: 1px solid <%= isSuccess ? "rgba(56, 189, 248, 0.3)" : "rgba(239, 68, 68, 0.3)" %>;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
        }
        .icon { font-size: 3.5rem; margin-bottom: 20px; color: <%= isSuccess ? "#38bdf8" : "#f87171" %>; }
        .loader-bar { height: 4px; background: rgba(255,255,255,0.05); border-radius: 10px; margin-top: 25px; overflow: hidden; }
        .fill { height: 100%; background: <%= isSuccess ? "#38bdf8" : "#f87171" %>; width: 0; animation: load 2s linear forwards; }
        @keyframes load { from { width: 0; } to { width: 100%; } }
    </style>
</head>
<body>

    <div class="status-card">
        <div class="icon">
            <i class="fas <%= isSuccess ? "fa-circle-check" : "fa-circle-xmark" %>"></i>
        </div>
        <h2><%= isSuccess ? "Message Sent!" : "Error Occurred" %></h2>
        <p><%= isSuccess ? "Redirecting to your inbox..." : "Error: " + errorTrace %></p>
        
        <div class="loader-bar">
            <div class="fill"></div>
        </div>
    </div>

    <script>
        setTimeout(function() {
            <% if (isSuccess) { %>
                window.location.href = "inbox.jsp";
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