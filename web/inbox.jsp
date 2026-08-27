<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%@page import="java.sql.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.TimeZone" %>
<%
    
    String currentUser = (String) session.getAttribute("loggedUser");
    String role = (String) session.getAttribute("userRole");
    
    if(currentUser == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Inbox - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Poppins", sans-serif;
            background: radial-gradient(circle at center, #0d0d2b 0%, #050505 100%);
            color: #ffffff;
            min-height: 100vh;
            padding: 40px 20px;
        }

        .container {
            max-width: 850px;
            margin: 0 auto;
            position: relative;
            z-index: 10;
        }

        .inbox-header {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            padding: 30px;
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .header-info h2 {
            font-size: 1.8rem;
            background: linear-gradient(to right, #ff9900, #f2fe00);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header-info p { color: #aaa; font-size: 0.9rem; margin-top: 5px; }

        .back-link {
            color: #00d4ff;
            text-decoration: none;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
        }
        .back-link:hover { transform: translateX(-5px); color: #fff; }

        .msg-card {
            background: rgba(15, 23, 42, 0.7);
            border: 1px solid rgba(255, 255, 255, 0.05);
            padding: 25px;
            margin-bottom: 20px;
            border-radius: 20px;
            transition: 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .msg-card:hover {
            transform: translateY(-5px);
            border-color: rgba(0, 212, 255, 0.3);
            background: rgba(15, 23, 42, 0.9);
        }

        .unread {
            border-left: 5px solid #ff4b2b !important;
            box-shadow: 0 0 15px rgba(255, 75, 43, 0.1);
        }

        .unread::after {
            content: 'NEW';
            position: absolute;
            top: 15px; right: 20px;
            background: #ff4b2b;
            font-size: 10px; font-weight: bold;
            padding: 2px 8px; border-radius: 5px;
        }

        .msg-card h4 {
            font-size: 1.1rem;
            color: #00d4ff;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .msg-meta {
            font-size: 0.85rem;
            color: #888;
            margin-bottom: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            padding-bottom: 10px;
        }

        .msg-meta span { color: #ccc; margin-right: 15px; }

        .msg-body {
            background: rgba(255, 255, 255, 0.03);
            padding: 15px;
            border-radius: 12px;
            line-height: 1.6;
            color: #e2e8f0;
            border-left: 3px solid #ff9900;
        }

        .reply-area {
            margin-top: 15px;
            text-align: right;
        }

        .reply-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #006eff, #00d4ff);
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: bold;
            transition: 0.3s;
        }

        .reply-btn:hover {
            box-shadow: 0 5px 15px rgba(0, 212, 255, 0.4);
            transform: scale(1.05);
        }

        .empty-inbox {
            text-align: center;
            padding: 50px;
            color: #666;
        }
        .empty-inbox i { font-size: 4rem; margin-bottom: 20px; opacity: 0.5; }

    </style>
</head>
<body>

    <div class="container">
        <div class="inbox-header">
            <div class="header-info">
                <h2><i class="fas fa-inbox"></i> My Inbox</h2>
                <p>Welcome back, <strong><%= currentUser %></strong> (<%= role %>)</p>
            </div>
            
            <% if(role.equals("Teacher")) { %>
                <a href="teacherHome.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Dashboard</a>
            <% } else if(role.equals("Guardian")) { %>
                <a href="guardianHome.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Dashboard</a>
            <% } %>
        </div>

 <%
    if(conn != null) {
        PreparedStatement pst = null;
        ResultSet rs = null;
        PreparedStatement updatePst = null;
        try {
            String sql = "SELECT Sender_ID, Related_Student, Subject, Message_Body, Send_Date, Status " +
                         "FROM Messages WHERE Receiver_ID = ? ORDER BY Send_Date DESC";
            pst = conn.prepareStatement(sql);
            pst.setString(1, currentUser);
            rs = pst.executeQuery();
            
            boolean hasMessages = false;
            
            // Setting up SimpleDateFormat for Bangladesh Time (Asia/Dhaka) format like "MMM dd, yyyy, hh:mm a"
            SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy, hh:mm a");
            sdf.setTimeZone(TimeZone.getTimeZone("Asia/Dhaka"));
            
            while(rs.next()) {
                hasMessages = true;
                String statusClass = rs.getString("Status").equals("Unread") ? "unread" : "";
                
                Timestamp sendDate = rs.getTimestamp("Send_Date");
                String formattedDate = "";
                if(sendDate != null) {
                    formattedDate = sdf.format(sendDate);
                }
%>
                <div class="msg-card <%= statusClass %>">
                    <h4><i class="fas fa-envelope-open-text"></i> <%= rs.getString("Subject") %></h4>
                    
                    <div class="msg-meta">
                        <span><i class="fas fa-user"></i> From: <strong><%= rs.getString("Sender_ID") %></strong></span>
                        <span><i class="fas fa-child"></i> Student: <strong><%= rs.getString("Related_Student") %></strong></span>
                        <span><i class="fas fa-calendar-alt"></i> <%= formattedDate %></span>
                    </div>

                    <div class="msg-body">
                        <%= rs.getString("Message_Body") %>
                    </div>
                    
                    <div class="reply-area">
                        <a href="replyMessage.jsp?receiverID=<%= rs.getString("Sender_ID") %>&studentID=<%= rs.getString("Related_Student") %>&subject=RE: <%= rs.getString("Subject") %>" class="reply-btn">
                            <i class="fas fa-reply"></i> Send Reply
                        </a>
                    </div>
                </div>
<%
            }
            
            if(!hasMessages) {
%>
                <div class="empty-inbox">
                    <i class="fas fa-comment-slash"></i>
                    <h3>Your inbox is empty</h3>
                    <p>No messages found at the moment.</p>
                </div>
<%
            }
            
            String updateSql = "UPDATE Messages SET Status = 'Read' WHERE Receiver_ID = ? AND Status = 'Unread'";
            updatePst = conn.prepareStatement(updateSql);
            updatePst.setString(1, currentUser);
            updatePst.executeUpdate();
            
        } catch(Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        } finally {
            if(rs != null) { try { rs.close(); } catch(Exception e) {} }
            if(pst != null) { try { pst.close(); } catch(Exception e) {} }
            if(updatePst != null) { try { updatePst.close(); } catch(Exception e) {} }
        }
    }
%>
    </div>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>