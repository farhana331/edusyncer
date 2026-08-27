<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Teacher")) {
        response.sendRedirect("index.jsp");
        return;
    }
    String classID = request.getParameter("classID");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Take Attendance - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Poppins", sans-serif; }
        body { background: radial-gradient(circle at center, #0f172a 0%, #020617 100%); color: #fff; min-height: 100vh; padding: 40px 20px; }
        .container { max-width: 800px; margin: 0 auto; background: rgba(30, 41, 59, 0.5); backdrop-filter: blur(15px); border-radius: 20px; border: 1px solid rgba(255,255,255,0.1); padding: 30px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 15px; }
        .back-link { color: #94a3b8; text-decoration: none; transition: 0.3s; }
        .back-link:hover { color: #38bdf8; }
        .date-picker { margin-bottom: 20px; background: rgba(0,0,0,0.3); padding: 15px; border-radius: 12px; display: flex; align-items: center; gap: 15px; }
        .date-picker input { padding: 10px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.2); background: #0f172a; color: #fff; outline: none; }
        
        table { width: 100%; border-collapse: collapse; }
        th { background: rgba(56, 189, 248, 0.1); color: #38bdf8; padding: 15px; text-align: left; }
        td { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        tr:hover { background: rgba(255,255,255,0.02); }
      
        .radio-group { display: flex; gap: 15px; }
        .radio-group label { cursor: pointer; display: flex; align-items: center; gap: 5px; font-weight: bold; }
        .present-lbl { color: #4ade80; }
        .absent-lbl { color: #f87171; }
        
        .submit-btn { width: 100%; padding: 15px; background: linear-gradient(90deg, #f59e0b, #d97706); color: white; border: none; border-radius: 10px; font-weight: bold; font-size: 1.1rem; cursor: pointer; margin-top: 25px; transition: 0.3s; }
        .submit-btn:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(245, 158, 11, 0.3); }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h2><i class="fas fa-clipboard-list" style="color:#f59e0b;"></i> Daily Attendance: <%= classID %></h2>
        <a href="teacherHome.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Dashboard</a>
    </div>

    <% if(conn == null) { out.println("<h3 style='color:red;'>Database disconnected. Please restart server.</h3>"); } else { %>
    <form action="submitAttendanceProcess.jsp" method="POST">
        <input type="hidden" name="classID" value="<%= classID %>">
        
        <div class="date-picker">
            <label><strong>Select Date:</strong></label>
            <input type="date" name="dateMarked" required>
        </div>

        <table>
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <%
                    try {
                        String sql = "SELECT Student_ID, Student_Name FROM Students WHERE Class_ID = ? ORDER BY Student_ID";
                        PreparedStatement pst = conn.prepareStatement(sql);
                        pst.setString(1, classID);
                        ResultSet rs = pst.executeQuery();
                        
                        boolean hasStudents = false;
                        while(rs.next()) {
                            hasStudents = true;
                            String sID = rs.getString("Student_ID");
                %>
                        <tr>
                            <td style="font-weight: bold;"><%= sID %></td>
                            <td><%= rs.getString("Student_Name") %></td>
                            <td>
                                <input type="hidden" name="studentIDs" value="<%= sID %>">
                                
                                <div class="radio-group">
                                    <label class="present-lbl">
                                        <input type="radio" name="status_<%= sID %>" value="Present" required> Present
                                    </label>
                                    <label class="absent-lbl">
                                        <input type="radio" name="status_<%= sID %>" value="Absent"> Absent
                                    </label>
                                </div>
                            </td>
                        </tr>
                <%
                        }
                        if(!hasStudents) { out.println("<tr><td colspan='3'>No students found in this class.</td></tr>"); }
                        rs.close(); pst.close();
                    } catch(Exception e) { out.println("Error: " + e.getMessage()); }
                %>
            </tbody>
        </table>

        <button type="submit" class="submit-btn"><i class="fas fa-save"></i> Save Attendance</button>
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