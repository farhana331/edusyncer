<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Teacher")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String guardianID = request.getParameter("guardianID");
    String studentID = request.getParameter("studentID");

    if(guardianID == null || studentID == null) {
%>
        <div style="background:#020617; color:#f87171; height:100vh; display:flex; justify-content:center; align-items:center; font-family:sans-serif;">
            <h3>Missing context. Please go back to your roster.</h3>
        </div>
<%
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Message Guardian | EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap');

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            background-color: #020617;
            color: #f1f5f9;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .messenger-card {
            background: rgba(30, 41, 59, 0.4);
            backdrop-filter: blur(15px);
            width: 100%;
            max-width: 550px;
            border-radius: 24px;
            border: 1px solid rgba(245, 158, 11, 0.2); 
            padding: 40px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .header {
            text-align: center;
            margin-bottom: 30px;
        }

        .header h2 {
            color: #f59e0b; 
            font-size: 1.6rem;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 12px;
        }

        .info-strip {
            background: rgba(245, 158, 11, 0.05);
            padding: 15px;
            border-radius: 15px;
            margin-bottom: 25px;
            border-left: 4px solid #f59e0b;
        }

        .info-strip p {
            font-size: 0.9rem;
            color: #94a3b8;
            margin-bottom: 5px;
        }

        .info-strip span { color: #f1f5f9; font-weight: 500; }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 0.85rem;
            color: #38bdf8;
            font-weight: 500;
        }

        input[type="text"], textarea {
            width: 100%;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            padding: 12px 15px;
            color: #fff;
            margin-bottom: 20px;
            font-size: 0.95rem;
            transition: 0.3s;
        }

        input:focus, textarea:focus {
            outline: none;
            border-color: #f59e0b;
            background: rgba(15, 23, 42, 0.8);
            box-shadow: 0 0 15px rgba(245, 158, 11, 0.1);
        }

        .btn-send {
            width: 100%;
            background: #f59e0b;
            color: #fff;
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: 0.3s;
        }

        .btn-send:hover {
            background: #d97706;
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(245, 158, 11, 0.2);
        }

        .back-nav {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.85rem;
            margin-bottom: 20px;
            transition: 0.3s;
        }

        .back-nav:hover { color: #f1f5f9; }
    </style>
</head>
<body>

    <div class="messenger-card">
        <a href="teacherHome.jsp" class="back-nav">
            <i class="fas fa-arrow-left"></i> Back to Dashboard
        </a>

        <div class="header">
            <h2><i class="fas fa-paper-plane"></i> Send Message</h2>
        </div>

        <div class="info-strip">
            <p>Recipient: <span>Guardian ID - <%= guardianID %></span></p>
            <p>Regarding: <span>Student ID - <%= studentID %></span></p>
        </div>

        <form action="sendMessageProcess.jsp" method="POST">
            <input type="hidden" name="receiverID" value="<%= guardianID %>">
            <input type="hidden" name="studentID" value="<%= studentID %>">

            <label><i class="fas fa-heading"></i> Subject</label>
            <input type="text" name="subject" placeholder="e.g., Behavior Update, Attendance" required>

            <label><i class="fas fa-pen-nib"></i> Message</label>
            <textarea name="messageBody" rows="5" placeholder="Type your message clearly here..." required></textarea>

            <button type="submit" class="btn-send">
                Send Message <i class="fas fa-chevron-right"></i>
            </button>
        </form>
    </div>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>