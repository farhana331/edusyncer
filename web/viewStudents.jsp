<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Teacher")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String classID = request.getParameter("classID");
    String subjectID = request.getParameter("subjectID");
    
    if(classID == null || subjectID == null) {
        response.sendRedirect("teacherHome.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Class Roster | EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap');

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            background-color: #020617;
            color: #f1f5f9;
            min-height: 100vh;
            padding: 40px 20px;
            background-image: 
                radial-gradient(circle at 10% 20%, rgba(56, 189, 248, 0.05) 0%, transparent 40%),
                radial-gradient(circle at 90% 80%, rgba(30, 58, 138, 0.1) 0%, transparent 40%);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header-card {
            background: rgba(30, 41, 59, 0.4);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(56, 189, 248, 0.2);
            padding: 30px;
            border-radius: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }

        .header-info h2 {
            font-size: 1.8rem;
            color: #38bdf8;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 5px;
        }

        .header-info p {
            color: #94a3b8;
            font-size: 0.95rem;
        }

        .header-info span {
            color: #f1f5f9;
            font-weight: 500;
            background: rgba(56, 189, 248, 0.1);
            padding: 2px 10px;
            border-radius: 6px;
        }

        .back-link {
            text-decoration: none;
            color: #fff;
            background: rgba(255, 255, 255, 0.05);
            padding: 10px 20px;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .back-link:hover {
            background: #38bdf8;
            color: #020617;
            transform: translateX(-5px);
        }

        .table-container {
            background: rgba(15, 23, 42, 0.6);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            background: rgba(56, 189, 248, 0.1);
            color: #38bdf8;
            text-align: left;
            padding: 20px;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 2px solid rgba(56, 189, 248, 0.2);
        }

        td {
            padding: 18px 20px;
            color: #cbd5e1;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 0.95rem;
        }

        tr:hover {
            background: rgba(255, 255, 255, 0.02);
        }

        .g-meta {
            font-size: 0.82rem;
            color: #94a3b8;
            display: block;
            margin-top: 3px;
        }
        .g-meta i {
            width: 14px;
            margin-right: 4px;
            color: #38bdf8;
        }

        .btn-group {
            display: flex;
            gap: 10px;
        }

        .action-btn {
            padding: 8px 16px;
            border-radius: 8px;
            text-decoration: none;
            font-size: 0.85rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: 0.3s;
        }

        .btn-grade {
            background: rgba(56, 189, 248, 0.1);
            color: #38bdf8;
            border: 1px solid rgba(56, 189, 248, 0.3);
        }

        .btn-grade:hover {
            background: #38bdf8;
            color: #020617;
        }

        .btn-msg {
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }

        .btn-msg:hover {
            background: #f59e0b;
            color: #fff;
        }

        .empty-state {
            padding: 50px;
            text-align: center;
            color: #64748b;
            font-style: italic;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header-card">
        <div class="header-info">
            <h2><i class="fas fa-users-rectangle"></i> Class Roster</h2>
            <p>
                Class: <span><%= classID %></span> 
                Subject: <span><%= subjectID %></span>
            </p>
        </div>
        <a href="teacherHome.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i> Dashboard
        </a>
    </div>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Student Name</th>
                    <th>Guardian Details</th> 
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if(conn != null) {
                        try {
                            String sql = "SELECT s.Student_ID, s.Student_Name, s.Guardian_ID, " +
                                         "u.Name AS Guardian_Name, u.Phone AS Guardian_Phone " +
                                         "FROM Students s " +
                                         "LEFT JOIN Users u ON s.Guardian_ID = u.User_ID " +
                                         "WHERE s.Class_ID = ? " +
                                         "ORDER BY s.Student_ID ASC";
                                         
                            PreparedStatement pst = conn.prepareStatement(sql);
                            pst.setString(1, classID);
                            ResultSet rs = pst.executeQuery();
                            
                            boolean hasStudents = false;
                            
                            while(rs.next()) {
                                hasStudents = true;
                                String sID = rs.getString("Student_ID");
                                String gID = rs.getString("Guardian_ID");
                                String gName = rs.getString("Guardian_Name");
                                String gPhone = rs.getString("Guardian_Phone");
                %>
                <tr>
                    <td style="font-weight: 600; color: #fff;"><%= sID %></td>
                    <td><%= rs.getString("Student_Name") %></td>
                    
                    <td>
                        <span style="font-weight: 500; color: #f59e0b;"><%= gID != null ? gID : "N/A" %></span>
                        <span class="g-meta"><i class="fas fa-user"></i> <%= gName != null ? gName : "N/A" %></span>
                        <span class="g-meta"><i class="fas fa-phone"></i> <%= gPhone != null ? gPhone : "N/A" %></span>
                    </td>
                    
                    <td>
                        <div class="btn-group">
                            <a href="enterMarks.jsp?studentID=<%= sID %>&subjectID=<%= subjectID %>&classID=<%= classID %>" class="action-btn btn-grade">
                                <i class="fas fa-pen-to-square"></i> Enter Marks
                            </a>
                            <a href="messageGuardian.jsp?guardianID=<%= gID %>&studentID=<%= sID %>" class="action-btn btn-msg">
                                <i class="fas fa-envelope"></i> Message
                            </a>
                        </div>
                    </td>
                </tr>
                <%
                            }
                            rs.close();
                            pst.close();
                        } catch(Exception e) {
                %>
                <tr>
                    <td colspan="4" style="color: #ef4444; text-align: center; padding: 20px;">
                        Error loading roster: <%= e.getMessage() %>
                    </td>
                </tr>
                <%
                        }
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>