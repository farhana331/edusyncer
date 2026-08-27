<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Teacher")) {
        response.sendRedirect("index.jsp");
        return;
    }
    String teacherID = (String) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Poppins", sans-serif;
            background: radial-gradient(circle at center, #0d0d2b 0%, #050505 100%);
            color: #ffffff;
            min-height: 100vh;
            overflow-x: hidden;
            position: relative;
        }
        .particles {
            position: fixed;
            width: 100%; height: 100%;
            z-index: 1; pointer-events: none;
        }
        .p {
            position: absolute;
            background: rgba(0, 212, 255, 0.15);
            border-radius: 50%; animation: float 15s infinite linear;
        }
        @keyframes float {
            0% { transform: translateY(110vh) scale(0.5); opacity: 0; }
            50% { opacity: 0.5; }
            100% { transform: translateY(-10vh) scale(1.2); opacity: 0; }
        }

        .header {
            position: sticky;
            top: 0;
            display: flex; justify-content: space-between; align-items: center;
            padding: 15px 50px;
            background: rgba(15, 23, 42, 0.8);
            backdrop-filter: blur(15px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            z-index: 100;
        }

        .header h2 {
            font-size: 1.4rem;
            background: linear-gradient(to right, #00d4ff, #ffffff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .nav-links { display: flex; align-items: center; gap: 20px; }

        .inbox-btn {
            background: linear-gradient(135deg, #ff9900, #ff5500);
            padding: 8px 18px; border-radius: 10px;
            color: white; text-decoration: none; font-weight: 600;
            font-size: 0.9rem; transition: 0.3s;
            display: flex; align-items: center; gap: 8px;
        }
        .inbox-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(255, 153, 0, 0.3); }

        .logout-btn {
            color: #ff4b2b; text-decoration: none; font-weight: bold;
            font-size: 0.9rem; display: flex; align-items: center; gap: 5px;
        }
        .logout-btn:hover { color: #ff8a71; }

        .container {
            max-width: 1000px; margin: 40px auto;
            padding: 0 20px; position: relative; z-index: 10;
        }

        .welcome-card {
            background: linear-gradient(145deg, rgba(30, 41, 59, 0.6), rgba(15, 23, 42, 0.8));
            padding: 30px; border-radius: 20px;
            border: 1px solid rgba(255, 255, 255, 0.05);
            margin-bottom: 30px;
            backdrop-filter: blur(10px);
        }

        .welcome-card h3 {
            font-size: 1.5rem; margin-bottom: 15px; color: #00d4ff;
            display: flex; align-items: center; gap: 10px;
        }

        .table-container {
            background: rgba(15, 23, 42, 0.7);
            border-radius: 20px; overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.4);
        }

        table { width: 100%; border-collapse: collapse; }

        th {
            background: rgba(0, 110, 255, 0.2); color: #00d4ff; padding: 18px;
            text-align: left; font-size: 0.9rem;
            text-transform: uppercase; letter-spacing: 1px;
        }

        td {
            padding: 16px 18px; border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            font-size: 0.95rem; color: #e2e8f0;
        }

        tr:hover { background: rgba(255, 255, 255, 0.03); }

        .view-btn {
            background: linear-gradient(135deg, #28a745, #1e7e34); color: white; padding: 8px 16px;
            border-radius: 8px; text-decoration: none;
            font-size: 0.85rem; font-weight: 600;
            display: inline-flex; justify-content: center; align-items: center; gap: 6px;
            transition: 0.3s;
        }
        .view-btn:hover {
            transform: scale(1.05); box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        .empty-state { text-align: center; padding: 30px; color: #888; }

    </style>
</head>
<body>

    <div class="particles">
        <div class="p" style="width: 5px; height: 5px; left: 10%; animation-delay: 0s;"></div>
        <div class="p" style="width: 3px; height: 3px; left: 40%; animation-delay: 2s;"></div>
        <div class="p" style="width: 7px; height: 7px; left: 70%; animation-delay: 4s;"></div>
        <div class="p" style="width: 4px; height: 4px; left: 85%; animation-delay: 1s;"></div>
    </div>

    <div class="header">
        <h2><i class="fas fa-graduation-cap"></i> Welcome Teacher, <%= teacherID %></h2>
        <div class="nav-links">
            <a href="inbox.jsp" class="inbox-btn">
                <i class="fas fa-envelope"></i> Check Messages
            </a>
            <a href="logout.jsp" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>

    <div class="container">
        <div class="welcome-card">
            <h3><i class="fas fa-layer-group"></i> My Allocated Classes</h3>
            <p style="color: #888; font-size: 0.9rem;">Management and student overview for your assigned academic courses.</p>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-school"></i> Class Name</th>
                        <th><i class="fas fa-book-open"></i> Subject Name</th>
                        <th><i class="fas fa-cog"></i> Action</th>
                    </tr>
                </thead>
                <tbody>
                   <%
    if(conn != null) {
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT c.Class_Name, s.Subject_Name, c.Class_ID, s.Subject_ID " +
                         "FROM Teacher_Allocation ta " +
                         "JOIN Classes c ON ta.Class_ID = c.Class_ID " +
                         "JOIN Subjects s ON ta.Subject_ID = s.Subject_ID " +
                         "WHERE ta.Teacher_ID = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, teacherID);
            rs = pst.executeQuery();
            
            boolean hasClasses = false;
            while(rs.next()) {
                hasClasses = true;
%>
                <tr>
                    <td><strong><%= rs.getString("Class_Name") %></strong></td>
                    <td><%= rs.getString("Subject_Name") %></td>
                    
                    <td>
                        <div style="display: flex; flex-direction: column; gap: 8px;">
                            <a href="viewStudents.jsp?classID=<%= rs.getString("Class_ID") %>&subjectID=<%= rs.getString("Subject_ID") %>" class="view-btn">
                                <i class="fas fa-users"></i> View Students
                            </a>
                            <a href="takeAttendance.jsp?classID=<%= rs.getString("Class_ID") %>" class="view-btn" style="background: rgba(245, 158, 11, 0.1); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.3);">
                                <i class="fas fa-clipboard-check"></i> Take Attendance
                            </a>
                        </div>
                    </td>
                </tr>
<%
            }
            
            if(!hasClasses) {
%>
                <tr>
                    <td colspan="3" class="empty-state">
                         <i class="fas fa-info-circle"></i> No classes assigned yet. Please contact the Admin.
                    </td>
                </tr>
<%
            }
        } catch(Exception e) {
%>
            <tr>
                <td colspan="3" style="color: #ff4b2b; padding: 20px; text-align: center;">
                    Error loading classes: <%= e.getMessage() %>
                </td>
            </tr>
<%
        } finally {
            if(rs != null) { try { rs.close(); } catch(Exception e) {} }
            if(pst != null) { try { pst.close(); } catch(Exception e) {} }
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