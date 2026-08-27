<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Teacher")) {
        response.sendRedirect("index.jsp");
        return;
    }
    String studentID = request.getParameter("studentID");
    String subjectID = request.getParameter("subjectID");
    String classID = request.getParameter("classID");
    

    if(studentID == null || subjectID == null) {
        out.println("<h3 style='color:white; text-align:center; margin-top:50px;'>Missing Student or Subject Data!</h3>");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Enter Student Marks | EduSyncer</title>
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
            background: rgba(255, 255, 255, 0.05);
            animation: animate 20s linear infinite;
            bottom: -150px;
            border-radius: 50%;
        }

        @keyframes animate {
            0% { transform: translateY(0) rotate(0deg); opacity: 1; }
            100% { transform: translateY(-1000px) rotate(720deg); opacity: 0; }
        }

        .grading-card {
            background: rgba(30, 41, 59, 0.45);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 40px;
            border-radius: 30px;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 25px 50px rgba(0,0,0,0.5);
            position: relative;
            z-index: 1;
        }

        .back-nav {
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 25px;
            transition: 0.3s;
        }

        .back-nav:hover { color: #38bdf8; transform: translateX(-5px); }

        .header h2 {
            font-size: 1.6rem;
            color: #fff;
            margin-bottom: 5px;
            letter-spacing: 1px;
        }

        .header p {
            color: #94a3b8;
            font-size: 0.9rem;
            margin-bottom: 25px;
        }

        .info-box {
            background: rgba(56, 189, 248, 0.07);
            border-left: 4px solid #38bdf8;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 25px;
        }

        .info-box div { font-size: 0.85rem; margin-bottom: 4px; }
        .info-box strong { color: #38bdf8; }

        label {
            display: block;
            font-size: 0.85rem;
            color: #cbd5e1;
            margin: 15px 0 8px 5px;
        }

        input, select, textarea {
            width: 100%;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 12px 18px;
            color: #fff;
            font-size: 0.9rem;
            transition: 0.3s;
            outline: none;
        }

        input:focus, select:focus, textarea:focus {
            border-color: #38bdf8;
            background: rgba(15, 23, 42, 0.8);
            box-shadow: 0 0 15px rgba(56, 189, 248, 0.1);
        }

        select option {
            background: #0f172a;
            color: #fff;
        }

        .btn-save {
            width: 100%;
            background: linear-gradient(90deg, #0ea5e9, #6366f1);
            color: #fff;
            border: none;
            padding: 14px;
            border-radius: 12px;
            font-weight: 600;
            margin-top: 30px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: 0.4s;
        }

        .btn-save:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(56, 189, 248, 0.3);
            filter: brightness(1.1);
        }

        .icon-btn { font-size: 1.1rem; }
    </style>
</head>
<body>

    <div class="particles">
        <span style="left: 10%; width: 40px; height: 40px; animation-delay: 0s;"></span>
        <span style="left: 30%; width: 20px; height: 20px; animation-delay: 2s;"></span>
        <span style="left: 70%; width: 60px; height: 60px; animation-delay: 4s;"></span>
        <span style="left: 85%; width: 30px; height: 30px; animation-delay: 1s;"></span>
    </div>

    <div class="grading-card">
        <a href="viewStudents.jsp?classID=<%= classID %>&subjectID=<%= subjectID %>" class="back-nav">
            <i class="fas fa-arrow-left"></i> Back to Roster
        </a>

        <div class="header">
            <h2>Academic Grading</h2>
            <p>Update student examination records</p>
        </div>

        <div class="info-box">
            <div><strong>Student ID:</strong> <%= studentID %></div>
            <div><strong>Subject Code:</strong> <%= subjectID %></div>
            <% if(classID != null) { %>
                <div><strong>Class Section:</strong> <%= classID %></div>
            <% } %>
        </div>

        <form action="submitMarksProcess.jsp" method="POST">
            <input type="hidden" name="studentID" value="<%= studentID %>">
            <input type="hidden" name="subjectID" value="<%= subjectID %>">
            <input type="hidden" name="classID" value="<%= classID %>">

            <label><i class="fas fa-calendar-alt"></i> Exam Term</label>
            <select name="examTerm" required>
                <option value="" disabled selected>Select Term</option>
                <option value="Half-Yearly">Half-Yearly Exam</option>
                <option value="Final">Final Exam</option>
            </select>

            <label><i class="fas fa-star"></i> Marks Obtained (0 - 100)</label>
            <input type="number" name="marks" min="0" max="100" placeholder="Enter score" required>

            <label><i class="fas fa-comment-dots"></i> Teacher Remarks</label>
            <textarea name="remarks" rows="3" placeholder="Add comments on performance..."></textarea>

            <button type="submit" class="btn-save">
                <i class="fas fa-save icon-btn"></i> Save Marks
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