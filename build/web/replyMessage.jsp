<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    
    String role = (String) session.getAttribute("userRole");
    if(role == null ) {
        response.sendRedirect("index.jsp");
        return;
    }

    String teacherID = request.getParameter("receiverID");
    String studentID = request.getParameter("studentID");
    String subjectLine = request.getParameter("subject");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reply to Teacher | EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap');

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            background: linear-gradient(-45deg, #020617, #0f172a, #1e1b4b, #020617);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            color: #f1f5f9;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .particles {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            overflow: hidden; z-index: -1;
        }

        .particles span {
            position: absolute;
            display: block;
            list-style: none;
            width: 20px; height: 20px;
            background: rgba(255, 255, 255, 0.1);
            animation: animate 25s linear infinite;
            bottom: -150px;
            border-radius: 50%;
        }

        @keyframes animate {
            0% { transform: translateY(0) rotate(0deg); opacity: 1; border-radius: 0; }
            100% { transform: translateY(-1000px) rotate(720deg); opacity: 0; border-radius: 50%; }
        }
        .reply-card {
            background: rgba(30, 41, 59, 0.45);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 40px;
            border-radius: 30px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            z-index: 1;
            position: relative;
        }

        .back-nav {
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 20px;
            transition: 0.3s;
        }

        .back-nav:hover { color: #38bdf8; }

        .header h2 {
            font-size: 1.5rem;
            color: #fff;
            margin-bottom: 10px;
        }

        .info-pill {
            background: rgba(56, 189, 248, 0.1);
            border: 1px solid rgba(56, 189, 248, 0.2);
            padding: 12px;
            border-radius: 15px;
            margin-bottom: 25px;
        }

        .info-pill h4 { color: #38bdf8; font-size: 0.9rem; }
        .info-pill p { color: #cbd5e1; font-size: 0.8rem; }

        .error-box {
            background: rgba(239, 68, 68, 0.1);
            border: 1px solid rgba(239, 68, 68, 0.2);
            color: #fca5a5;
            padding: 20px;
            border-radius: 15px;
            text-align: center;
        }

        label {
            display: block;
            font-size: 0.8rem;
            color: #94a3b8;
            margin-bottom: 8px;
            margin-left: 5px;
        }

        input, textarea {
            width: 100%;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            padding: 12px 18px;
            color: #fff;
            margin-bottom: 20px;
            font-size: 0.9rem;
            transition: 0.3s;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #38bdf8;
            background: rgba(15, 23, 42, 0.8);
        }

        .btn-send {
            width: 100%;
            background: linear-gradient(90deg, #38bdf8, #818cf8);
            color: #fff;
            border: none;
            padding: 14px;
            border-radius: 15px;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: 0.3s;
        }

        .btn-send:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(56, 189, 248, 0.3);
            filter: brightness(1.1);
        }
    </style>
</head>
<body>

    <div class="particles">
        <span style="left: 10%; width: 80px; height: 80px; animation-delay: 0s;"></span>
        <span style="left: 20%; width: 20px; height: 20px; animation-delay: 2s; animation-duration: 12s;"></span>
        <span style="left: 70%; width: 40px; height: 40px; animation-delay: 4s;"></span>
        <span style="left: 40%; width: 60px; height: 60px; animation-delay: 0s; animation-duration: 18s;"></span>
        <span style="left: 85%; width: 25px; height: 25px; animation-delay: 7s;"></span>
    </div>

    <div class="reply-card">
        <a href="inbox.jsp" class="back-nav">
            <i class="fas fa-chevron-left"></i> Back to Inbox
        </a>

        <div class="header">
            <h2>Compose Reply</h2>
        </div>

        <% if (teacherID == null || teacherID.trim().isEmpty() || teacherID.equals("null")) { %>
            <div class="error-box">
                <i class="fas fa-exclamation-triangle" style="font-size: 2rem; margin-bottom: 10px;"></i>
                <p>Teacher context missing!</p>
                <a href="inbox.jsp" style="color:#f87171; text-decoration:none; font-size: 0.8rem; margin-top:10px; display:block;">Return to Inbox</a>
            </div>
        <% } else { %>
            
            <div class="info-pill">
                <h4><i class="fas fa-user-tie"></i> Teacher: <%= teacherID %></h4>
                <p><i class="fas fa-id-card"></i> Regarding Student: <%= studentID %></p>
            </div>
            
           <form action="sendMessageProcess.jsp" method="POST">
    <input type="hidden" name="receiverID" value="<%= teacherID %>">
    <input type="hidden" name="studentID" value="<%= studentID %>">

    <label>Subject</label>
    <input type="text" name="subject" value="<%= subjectLine != null ? subjectLine : "" %>" required>

    <label>Your Message</label>
    <textarea name="messageBody" rows="5" placeholder="Type your reply here..." required></textarea>

    <button type="submit" class="btn-send">
        Send Reply <i class="fas fa-paper-plane"></i>
    </button>
</form>

        <% } %>
    </div>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>