<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ include file="dbConnect.jsp" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String studentID = request.getParameter("studentID");
    boolean isSuccess = false;
    String errorTrace = "";
    String guardianID = null;

    if(conn != null && studentID != null) {
        try {
            conn.setAutoCommit(false);
            
            PreparedStatement ps0 = conn.prepareStatement("SELECT Guardian_ID FROM Students WHERE Student_ID = ?");
            ps0.setString(1, studentID);
            ResultSet rs0 = ps0.executeQuery();
            if(rs0.next()){
                guardianID = rs0.getString("Guardian_ID");
            }
            rs0.close(); ps0.close();

            String[] deleteQueries = {
                "DELETE FROM Attendance WHERE Student_ID = ?",
                "DELETE FROM Exam_Marks WHERE Student_ID = ?",
                "DELETE FROM Messages WHERE Related_Student = ?",
                "DELETE FROM Students WHERE Student_ID = ?",
                "DELETE FROM Users WHERE User_ID = ?"
            };

            for (String sql : deleteQueries) {
                try {
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setString(1, studentID);
                    ps.executeUpdate();
                    ps.close();
                } catch(SQLException e) {
                }
            }

            if(guardianID != null) {
                String[] guardianQueries = {
                    "DELETE FROM Guardians WHERE Guardian_ID = ?",
                    "DELETE FROM Users WHERE User_ID = ?"
                };
                for (String sql : guardianQueries) {
                    try {
                        PreparedStatement ps = conn.prepareStatement(sql);
                        ps.setString(1, guardianID);
                        ps.executeUpdate();
                        ps.close();
                    } catch(SQLException e) {
                    }
                }
            }

            conn.commit();
            isSuccess = true;
        } catch(Exception e) {
            if(conn != null) conn.rollback();
            isSuccess = false;
            errorTrace = e.getMessage();
        } finally {
            if(conn != null) { conn.setAutoCommit(true); conn.close(); }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Processing Deletion...</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;600&display=swap');
        body { background: #020617; color: #f1f5f9; font-family: 'Poppins', sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
        .card { background: rgba(30, 41, 59, 0.45); backdrop-filter: blur(15px); padding: 40px; border-radius: 25px; text-align: center; max-width: 400px; width: 90%; border: 1px solid <%= isSuccess ? "#38bdf84d" : "#f871714d" %>; box-shadow: 0 20px 50px rgba(0,0,0,0.5); }
        .icon { font-size: 3.5rem; margin-bottom: 20px; color: <%= isSuccess ? "#38bdf8" : "#f87171" %>; }
        .loader { height: 4px; background: rgba(255,255,255,0.05); border-radius: 10px; margin-top: 25px; overflow: hidden; }
        .fill { height: 100%; background: <%= isSuccess ? "#38bdf8" : "#f87171" %>; width: 0; animation: load 2s linear forwards; }
        @keyframes load { from { width: 0; } to { width: 100%; } }
    </style>
</head>
<body>
    <div class="card">
        <div class="icon">
            <i class="fas <%= isSuccess ? "fa-user-slash" : "fa-circle-exclamation" %>"></i>
        </div>
        <h2><%= isSuccess ? "Account Deleted" : "Error Occurred" %></h2>
        <p style="font-size: 0.9rem; color: #94a3b8; margin-top: 10px;">
            <%= isSuccess ? "Student and linked records removed." : "Error: " + errorTrace %>
        </p>
        <div class="loader"><div class="fill"></div></div>
    </div>

    <script>
        setTimeout(() => {
            window.location.href = "manageStudents.jsp";
        }, 2000);
    </script>
</body>
</html>