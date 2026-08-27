<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%@page import="java.sql.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || (!role.equals("Guardian") && !role.equals("Student"))) {
        response.sendRedirect("index.jsp");
        return;
    }

    String studentID = request.getParameter("studentID");
    if(studentID == null) {
        response.sendRedirect("guardianHome.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Academic Report Card</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Poppins", sans-serif;
            background: #020617;
            color: #f1f5f9;
            padding: 40px 20px;
            min-height: 100vh;
            position: relative;
            overflow-x: hidden;
        }

        body::before {
            content: "";
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: radial-gradient(circle at 20% 30%, #1e3a8a 0%, transparent 40%),
                        radial-gradient(circle at 80% 70%, #312e81 0%, transparent 40%),
                        radial-gradient(circle at 50% 50%, #020617 0%, #020617 100%);
            z-index: -2;
            animation: moveGradient 10s ease infinite alternate;
        }

        @keyframes moveGradient {
            0% { transform: scale(1) translate(0, 0); }
            100% { transform: scale(1.1) translate(2%, 2%); }
        }
        .particles-container {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            z-index: -1;
            pointer-events: none;
        }

        .particle {
            position: absolute;
            background: rgba(56, 189, 248, 0.4);
            border-radius: 50%;
            filter: blur(3px);
            animation: floatUp 15s infinite linear;
        }

        @keyframes floatUp {
            0% { transform: translateY(110vh) scale(0); opacity: 0; }
            50% { opacity: 0.5; }
            100% { transform: translateY(-10vh) scale(1.2); opacity: 0; }
        }

        .report-container { max-width: 1100px; margin: 0 auto; position: relative; }

        .header-banner {
            background: rgba(30, 41, 59, 0.4);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(56, 189, 248, 0.2);
            padding: 25px 35px;
            border-radius: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.5);
        }

        .header-banner h2 { color: #38bdf8; display: flex; align-items: center; gap: 12px; font-size: 1.7rem; }

        .back-btn {
            color: #fff;
            text-decoration: none;
            background: rgba(56, 189, 248, 0.15);
            padding: 10px 22px;
            border-radius: 12px;
            border: 1px solid rgba(56, 189, 248, 0.3);
            transition: 0.3s;
            font-weight: 500;
        }

        .back-btn:hover { background: #38bdf8; color: #000; transform: translateY(-2px); }

        .section-title {
            font-size: 1.3rem;
            margin: 30px 0 15px;
            color: #7dd3fc;
            padding-left: 15px;
            border-left: 4px solid #38bdf8;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .table-card {
            background: rgba(15, 23, 42, 0.7);
            backdrop-filter: blur(12px);
            border-radius: 20px;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, 0.08);
            margin-bottom: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
        }

        table { width: 100%; border-collapse: collapse; }

        th {
            background: rgba(56, 189, 248, 0.1);
            color: #38bdf8;
            padding: 18px;
            text-align: left;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid rgba(56, 189, 248, 0.2);
        }

        td { padding: 18px; color: #cbd5e1; border-bottom: 1px solid rgba(255, 255, 255, 0.05); }

        .grade-pill {
            background: rgba(56, 189, 248, 0.1);
            color: #38bdf8;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            border: 1px solid rgba(56, 189, 248, 0.4);
        }

        .no-data { padding: 30px; text-align: center; color: #64748b; font-style: italic; }

    </style>
</head>
<body>

    <div class="particles-container">
        <div class="particle" style="width: 10px; height: 10px; left: 15%; animation-duration: 18s;"></div>
        <div class="particle" style="width: 6px; height: 6px; left: 40%; animation-duration: 12s; animation-delay: 2s;"></div>
        <div class="particle" style="width: 14px; height: 14px; left: 65%; animation-duration: 20s; animation-delay: 5s;"></div>
        <div class="particle" style="width: 8px; height: 8px; left: 85%; animation-duration: 15s; animation-delay: 1s;"></div>
    </div>

    <div class="report-container">
        <div class="header-banner">
            <div>
                <h2><i class="fas fa-file-invoice"></i> Academic Results</h2>
                <div style="color: #94a3b8; margin-top: 5px;">Student ID: <strong><%= studentID %></strong></div>
            </div>
            
            <a onclick="history.go(-1)" class="back-btn"><i class="fas fa-arrow-left"></i> Dashboard</a>
        </div>

        <div class="section-title"><i class="fas fa-calendar-check"></i> Half-Yearly Examination</div>
        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>Subject</th>
                        <th>Marks Obtained</th>
                        <th>Grade</th>
                        <th>Remarks</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if(conn != null) {
                            PreparedStatement pst = null;
                            ResultSet rs = null;
                            try {
                                String sql = "SELECT s.Subject_Name, e.Marks_Obtained, e.Grade, e.Teacher_Remarks " +
                                             "FROM Exam_Marks e JOIN Subjects s ON e.Subject_ID = s.Subject_ID " +
                                             "WHERE e.Student_ID = ? AND e.Exam_Term = 'Half-Yearly'";
                                pst = conn.prepareStatement(sql);
                                pst.setString(1, studentID);
                                rs = pst.executeQuery();
                                boolean hasData = false;
                                while(rs.next()) {
                                    hasData = true;
                    %>
                                    <tr>
                                        <td style="color: #fff;"><%= rs.getString("Subject_Name") %></td>
                                        <td style="color: #38bdf8; font-weight: bold;"><%= rs.getDouble("Marks_Obtained") %></td>
                                        <td><span class="grade-pill"><%= rs.getString("Grade") %></span></td>
                                        <td style="font-size: 0.9rem;"><%= rs.getString("Teacher_Remarks") != null ? rs.getString("Teacher_Remarks") : "-" %></td>
                                    </tr>
                    <%
                                }
                                if(!hasData) { out.println("<tr><td colspan='4' class='no-data'>No data published.</td></tr>"); }
                            } catch(Exception e) { out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>"); }
                            finally {
                                if(rs != null) { try { rs.close(); } catch(Exception e) {} }
                                if(pst != null) { try { pst.close(); } catch(Exception e) {} }
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>

        <div class="section-title"><i class="fas fa-trophy"></i> Final Examination</div>
        <div class="table-card">
            <table>
                <thead>
                    <tr>
                        <th>Subject</th>
                        <th>Marks Obtained</th>
                        <th>Grade</th>
                        <th>Remarks</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        if(conn != null) {
                            PreparedStatement pstFinal = null;
                            ResultSet rsFinal = null;
                            try {
                                String sqlFinal = "SELECT s.Subject_Name, e.Marks_Obtained, e.Grade, e.Teacher_Remarks " +
                                                  "FROM Exam_Marks e JOIN Subjects s ON e.Subject_ID = s.Subject_ID " +
                                                  "WHERE e.Student_ID = ? AND e.Exam_Term = 'Final'";
                                pstFinal = conn.prepareStatement(sqlFinal);
                                pstFinal.setString(1, studentID);
                                rsFinal = pstFinal.executeQuery();
                                boolean hasFinalData = false;
                                while(rsFinal.next()) {
                                    hasFinalData = true;
                    %>
                                    <tr>
                                        <td style="color: #fff;"><%= rsFinal.getString("Subject_Name") %></td>
                                        <td style="color: #38bdf8; font-weight: bold;"><%= rsFinal.getDouble("Marks_Obtained") %></td>
                                        <td><span class="grade-pill"><%= rsFinal.getString("Grade") %></span></td>
                                        <td style="font-size: 0.9rem;"><%= rsFinal.getString("Teacher_Remarks") != null ? rsFinal.getString("Teacher_Remarks") : "-" %></td>
                                    </tr>
                    <%
                                }
                                if(!hasFinalData) { out.println("<tr><td colspan='4' class='no-data'>Final exam results not yet available.</td></tr>"); }
                            } catch(Exception e) { out.println("<tr><td colspan='4'>Error: " + e.getMessage() + "</td></tr>"); }
                            finally {
                                if(rsFinal != null) { try { rsFinal.close(); } catch(Exception e) {} }
                                if(pstFinal != null) { try { pstFinal.close(); } catch(Exception e) {} }
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