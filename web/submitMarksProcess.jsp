<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ include file="dbConnect.jsp" %>
<%
    String sID = request.getParameter("studentID");
    String subID = request.getParameter("subjectID");
    String cID = request.getParameter("classID");
    String term = request.getParameter("examTerm");
    String marksStr = request.getParameter("marks");
    String remarks = request.getParameter("remarks");

    boolean isSuccess = false;
    String letterGrade = "F";
    String errorMsg = "";

    if(conn != null && marksStr != null) {
        PreparedStatement pst = null;
        try {
            double marks = Double.parseDouble(marksStr);
            if (marks >= 80) { letterGrade = "A+"; }
            else if (marks >= 70) { letterGrade = "A"; }
            else if (marks >= 60) { letterGrade = "A-"; }
            else if (marks >= 50) { letterGrade = "B"; }
            else if (marks >= 40) { letterGrade = "C"; }
            else if (marks >= 33) { letterGrade = "D"; }

            String sql = "INSERT INTO Exam_Marks (Mark_ID, Student_ID, Subject_ID, Exam_Term, Marks_Obtained, Grade, Teacher_Remarks) " +
                         "VALUES ((SELECT NVL(MAX(Mark_ID), 0) + 1 FROM Exam_Marks), ?, ?, ?, ?, ?, ?)";
                         
            pst = conn.prepareStatement(sql);
            pst.setString(1, sID);
            pst.setString(2, subID);
            pst.setString(3, term);
            pst.setDouble(4, marks);
            pst.setString(5, letterGrade);
            pst.setString(6, remarks);
            
            int row = pst.executeUpdate();
            if(row > 0) isSuccess = true;
                        
        } catch(Exception e) {
            isSuccess = false;
            errorMsg = e.getMessage();
        } finally {
            if(pst != null) { try { pst.close(); } catch(Exception e) {} }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Processing Result...</title>
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

        .grade-badge {
            display: inline-block;
            background: rgba(56, 189, 248, 0.15);
            color: #38bdf8;
            padding: 5px 15px;
            border-radius: 10px;
            font-weight: 600;
            margin: 10px 0;
            border: 1px solid rgba(56, 189, 248, 0.3);
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
            animation: load 3s linear forwards;
        }

        @keyframes load { from { width: 0; } to { width: 100%; } }
        
        .btn-manual {
            margin-top: 20px;
            display: inline-block;
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.8rem;
            transition: 0.3s;
        }
        .btn-manual:hover { color: #38bdf8; }
    </style>
</head>
<body>

    <div class="status-card">
        <div class="icon">
            <i class="fas <%= isSuccess ? "fa-circle-check" : "fa-circle-xmark" %>"></i>
        </div>
        
        <% if(isSuccess) { %>
            <h2>Marks Saved!</h2>
            <p style="margin-top: 10px;">The student's performance has been updated.</p>
            <div class="grade-badge">Grade: <%= letterGrade %></div>
        <% } else { %>
            <h2>Failed to Save</h2>
            <p style="color: #fca5a5; font-size: 0.85rem; margin-top: 10px;"><%= errorMsg %></p>
        <% } %>

        <div class="loader-bar">
            <div class="fill"></div>
        </div>
        
        <p style="font-size: 0.75rem; margin-top: 15px; color: #94a3b8;">
            <%= isSuccess ? "Redirecting to Class Roster..." : "Taking you back to form..." %>
        </p>

        <a href="viewStudents.jsp?classID=<%= cID %>&subjectID=<%= subID %>" class="btn-manual">Click here if not redirected</a>
    </div>

    <script>
        setTimeout(function() {
            <% if (isSuccess) { %>
                window.location.href = "viewStudents.jsp?classID=<%= cID %>&subjectID=<%= subID %>";
            <% } else { %>
                window.history.back();
            <% } %>
        }, 3000);
    </script>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>