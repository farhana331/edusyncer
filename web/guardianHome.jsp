<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Guardian")) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    String guardianID = (String) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guardian Dashboard | EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap');

        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            background-color: #020617;
            color: #f1f5f9;
            min-height: 100vh;
            padding: 30px;
            background-image: radial-gradient(circle at 10% 20%, rgba(15, 23, 42, 1) 0%, #020617 100%);
        }

        .header-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; padding-bottom: 20px; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .header-top h2 { font-size: 1.8rem; background: linear-gradient(90deg, #38bdf8, #818cf8); -webkit-background-clip: text; -webkit-text-fill-color: transparent; }
        
        .logout-btn { background: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 10px 20px; border-radius: 10px; text-decoration: none; font-weight: 500; transition: 0.3s; border: 1px solid rgba(239, 68, 68, 0.2); }
        .logout-btn:hover { background: #ef4444; color: #fff; }
        
        .inbox-btn { background: rgba(56, 189, 248, 0.1); color: #38bdf8; padding: 10px 20px; border-radius: 10px; text-decoration: none; font-weight: 500; transition: 0.3s; border: 1px solid rgba(56, 189, 248, 0.2); margin-right: 15px;}
        .inbox-btn:hover { background: #38bdf8; color: #000; }

        .dashboard-container { max-width: 1200px; margin: 0 auto; }

        .glass-panel { background: rgba(30, 41, 59, 0.4); backdrop-filter: blur(12px); border: 1px solid rgba(255,255,255,0.05); border-radius: 20px; padding: 30px; box-shadow: 0 20px 40px rgba(0,0,0,0.4); margin-bottom: 30px; }
        
        .panel-title { font-size: 1.2rem; color: #cbd5e1; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .panel-title i { color: #38bdf8; }

        table { width: 100%; border-collapse: collapse; }
        th { background: rgba(15, 23, 42, 0.6); color: #94a3b8; text-transform: uppercase; font-size: 0.85rem; padding: 15px; text-align: left; letter-spacing: 1px; }
        td { padding: 18px 15px; border-bottom: 1px solid rgba(255,255,255,0.02); color: #cbd5e1; vertical-align: middle; }
        tr:hover { background: rgba(255,255,255,0.01); }

        .btn-group { display: flex; gap: 8px; flex-wrap: wrap; }
        .report-btn { background: linear-gradient(135deg, #6366f1, #8b5cf6); color: white; padding: 8px 16px; border-radius: 8px; text-decoration: none; font-size: 0.85rem; font-weight: 500; display: inline-block; transition: 0.3s; }
        .report-btn:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(99, 102, 241, 0.4); }

        .teachers-btn { background: rgba(14, 165, 233, 0.1); color: #38bdf8; padding: 8px 16px; border-radius: 8px; text-decoration: none; font-size: 0.85rem; font-weight: 500; display: inline-block; border: 1px solid rgba(56, 189, 248, 0.3); transition: 0.3s; cursor: pointer; }
        .teachers-btn:hover { background: #38bdf8; color: #020617; }

        .progress-track { width: 100%; height: 8px; background: rgba(255,255,255,0.05); border-radius: 10px; overflow: hidden; margin-bottom: 5px; box-shadow: inset 0 1px 3px rgba(0,0,0,0.5); }
        .progress-fill { height: 100%; border-radius: 10px; transition: width 1s ease-in-out; }
        .att-stats { display: flex; justify-content: space-between; font-size: 0.8rem; color: #94a3b8; font-weight: 500; }

        .matrix-table { width: 100%; border-collapse: collapse; margin-top: 10px; background: rgba(0,0,0,0.2); border-radius: 10px; overflow: hidden; }
        .matrix-table th { background: rgba(255,255,255,0.02); color: #38bdf8; padding: 10px 15px; font-size: 0.8rem; text-align: center; }
        .matrix-table td { padding: 12px 15px; text-align: center; color: #cbd5e1; border-bottom: 1px solid rgba(255,255,255,0.02); }
        .matrix-table td.date-col { text-align: left; font-weight: 500; color: #fff; }
        .badge { padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; display: inline-flex; align-items: center; gap: 4px; }
        .badge-present { background: rgba(74, 222, 128, 0.15); color: #4ade80; border: 1px solid rgba(74, 222, 128, 0.3); }
        .badge-absent { background: rgba(248, 113, 113, 0.15); color: #f87171; border: 1px solid rgba(248, 113, 113, 0.3); }
        .badge-no-class { color: #64748b; font-size: 0.85rem; }
    </style>
</head>
<body>

<div class="dashboard-container">
    <div class="header-top">
        <h2><i class="fas fa-shield-halved"></i> Guardian Portal</h2>
        <div>
            <a href="inbox.jsp" class="inbox-btn"><i class="fas fa-envelope"></i> Messages</a>
            <a href="logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </div>
    </div>

    <div class="glass-panel">
        <h3 class="panel-title"><i class="fas fa-child"></i> My Linked Students</h3>
        <table>
            <thead>
                <tr>
                    <th>Student ID</th>
                    <th>Full Name</th>
                    <th>Class</th>
                    <th style="width: 220px;">Attendance Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if(conn != null) {
                        PreparedStatement pst = null;
                        ResultSet rs = null;
                        try {
                            String sql = "SELECT Student_ID, Student_Name, Class_ID FROM Students WHERE Guardian_ID = ?";
                            pst = conn.prepareStatement(sql);
                            pst.setString(1, guardianID);
                            rs = pst.executeQuery();
                            
                            boolean hasChildren = false;
                            while(rs.next()) {
                                hasChildren = true;
                                String sID = rs.getString("Student_ID");
                                String currentClass = rs.getString("Class_ID");
                                int totalDays = 0;
                                int presentDays = 0;
                                
                                PreparedStatement attPst = null;
                                ResultSet attRs = null;
                                try {
                                    String attSql = "SELECT COUNT(RECORD_ID) as TotalDays, " +
                                                    "SUM(CASE WHEN Status = 'Present' THEN 1 ELSE 0 END) as PresentDays " +
                                                    "FROM Attendance WHERE Student_ID = ?";
                                    attPst = conn.prepareStatement(attSql);
                                    attPst.setString(1, sID);
                                    attRs = attPst.executeQuery();
                                    
                                    if(attRs.next()) {
                                        totalDays = attRs.getInt("TotalDays");
                                        presentDays = attRs.getInt("PresentDays");
                                    }
                                } finally {
                                    if(attRs != null) { try { attRs.close(); } catch(Exception e) {} }
                                    if(attPst != null) { try { attPst.close(); } catch(Exception e) {} }
                                }

                                int percentage = 0;
                                String barColor = "#94a3b8"; 
                                
                                if(totalDays > 0) {
                                    percentage = (int) Math.round((presentDays * 100.0) / totalDays);
                                    if(percentage >= 80) barColor = "#4ade80"; 
                                    else if(percentage >= 60) barColor = "#facc15"; 
                                    else barColor = "#f87171";
                                }
                %>
                <tr>
                    <td style="font-weight: 600; color: #fff;"><%= sID %></td>
                    <td><%= rs.getString("Student_Name") %></td>
                    <td><span style="background: rgba(255,255,255,0.05); padding: 4px 12px; border-radius: 6px;"><%= currentClass %></span></td>
                    
                    <td>
                        <% if(totalDays == 0) { %>
                            <span style="color: #64748b; font-size: 0.85rem; font-style: italic;">No records yet</span>
                        <% } else { %>
                            <div class="progress-track">
                                <div class="progress-fill" style="width: <%= percentage %>%; background: <%= barColor %>; box-shadow: 0 0 10px <%= barColor %>;"></div>
                            </div>
                            <div class="att-stats">
                                <span><%= presentDays %> / <%= totalDays %> Classes</span>
                                <span style="color: <%= barColor %>;"><%= percentage %>%</span>
                            </div>
                        <% } %>
                    </td>

                    <td>
                        <div class="btn-group">
                            <a href="viewResults.jsp?studentID=<%= sID %>" class="report-btn">
                                <i class="fas fa-file-invoice"></i> View Report
                            </a>
                            <button type="button" class="teachers-btn" onclick="toggleTeachers('<%= sID %>')">
                                <i class="fas fa-user-tie"></i> Teachers
                            </button>
                            <button type="button" class="teachers-btn" onclick="toggleAttendance('<%= sID %>')" style="background: rgba(16, 185, 129, 0.1); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.3);">
                                <i class="fas fa-calendar-check"></i> Attendance Details
                            </button>
                        </div>
                    </td>
                </tr>

                <tr id="teachers-row-<%= sID %>" style="display: none; background: rgba(15, 23, 42, 0.3);">
                    <td colspan="5" style="padding: 20px;">
                        <h4 style="color: #38bdf8; font-size: 0.9rem; margin-bottom: 12px; text-transform: uppercase; letter-spacing: 0.5px;">
                            <i class="fas fa-book-open"></i> Assigned Teachers for Class <%= currentClass %>
                        </h4>
                        <table style="width: 100%; background: rgba(0,0,0,0.2); border-radius: 10px; overflow: hidden;">
                            <thead>
                                <tr style="background: rgba(255,255,255,0.02);">
                                    <th style="padding: 10px 15px; font-size: 0.8rem;">Subject Name</th>
                                      <th style="padding: 10px 15px; font-size: 0.8rem;">Teacher ID</th>
                                    <th style="padding: 10px 15px; font-size: 0.8rem;">Teacher Name</th>
                                    <th style="padding: 10px 15px; font-size: 0.8rem;">Contact Phone</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    PreparedStatement tPst = null;
                                    ResultSet tRs = null;
                                    try {
                                        String teacherSql = "SELECT sub.SUBJECT_NAME,u.User_ID As Teacher_ID, u.Name AS Teacher_Name, u.Phone AS Teacher_Phone " +
                                                             "FROM TEACHER_ALLOCATION ta " +
                                                             "JOIN SUBJECTS sub ON ta.SUBJECT_ID = sub.SUBJECT_ID " +
                                                             "JOIN USERS u ON ta.TEACHER_ID = u.User_ID " +
                                                             "WHERE ta.CLASS_ID = ? " +
                                                             "ORDER BY sub.SUBJECT_NAME ASC";
                                                                             
                                        tPst = conn.prepareStatement(teacherSql);
                                        tPst.setString(1, currentClass);
                                        tRs = tPst.executeQuery();
                                        
                                        boolean hasSubjects = false;
                                        while(tRs.next()) {
                                            hasSubjects = true;
                                %>
                                <tr>
                                    <td style="padding: 12px 15px; color: #f1f5f9; font-weight: 500;"><%= tRs.getString("SUBJECT_NAME") %></td>
                                      <td style="padding: 12px 15px; color: #f59e0b;"><i class="fas fa-user-tie" style="font-size:0.85rem; opacity:0.7; margin-right:5px;"></i> <%= tRs.getString("Teacher_ID") %></td>
                                    <td style="padding: 12px 15px; color: #f59e0b;"><i class="fas fa-user-tie" style="font-size:0.85rem; opacity:0.7; margin-right:5px;"></i> <%= tRs.getString("Teacher_Name") %></td>
                                    <td style="padding: 12px 15px; color: #cbd5e1;"><i class="fas fa-phone" style="font-size:0.85rem; opacity:0.7; margin-right:5px;"></i> <%= tRs.getString("Teacher_Phone") != null ? tRs.getString("Teacher_Phone") : "N/A" %></td>
                                </tr>
                                <%
                                        }
                                        if(!hasSubjects) {
                                %>
                                <tr>
                                    <td colspan="3" style="padding: 15px; text-align: center; color: #64748b; font-style: italic;">No subjects or teachers assigned to this class yet.</td>
                                </tr>
                                <% 
                                        }
                                    } finally {
                                        if(tRs != null) { try { tRs.close(); } catch(Exception e) {} }
                                        if(tPst != null) { try { tPst.close(); } catch(Exception e) {} }
                                    }
                                %>
                            </tbody>
                        </table>
                    </td>
                </tr>

                <tr id="attendance-row-<%= sID %>" style="display: none; background: rgba(15, 23, 42, 0.3);">
                    <td colspan="5" style="padding: 20px;">
                        <h4 style="color: #10b981; font-size: 0.9rem; margin-bottom: 12px; text-transform: uppercase; letter-spacing: 0.5px;">
                            <i class="fas fa-calendar-alt"></i> Subject-wise Attendance Grid
                        </h4>
                        <%
                            List<String[]> subjects = new ArrayList<>(); 
                            List<String> dates = new ArrayList<>();
                            Map<String, Map<String, String>> attendanceMatrix = new LinkedHashMap<>();

                            
                            boolean hasSubjectId = false;
                            boolean hasSubId = false;
                            boolean hasAllocId = false;
                            String dateCol = "DATE_MARKED"; 

                            try {
                                PreparedStatement colPst = conn.prepareStatement(
                                    "SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'ATTENDANCE'"
                                );
                                ResultSet colRs = colPst.executeQuery();
                                while(colRs.next()) {
                                    String col = colRs.getString("COLUMN_NAME").toUpperCase();
                                    if(col.equals("SUBJECT_ID")) hasSubjectId = true;
                                    else if(col.equals("SUB_ID")) hasSubId = true;
                                    else if(col.equals("ALLOC_ID")) hasAllocId = true;
                                    else if(col.equals("ATTENDANCE_DATE")) dateCol = "ATTENDANCE_DATE";
                                }
                                colRs.close();
                                colPst.close();
                            } catch(Exception ex) {
                                hasSubjectId = false;
                                hasAllocId = false;
                            }

                            PreparedStatement pstSubs = null;
                            ResultSet rsSubs = null;
                            PreparedStatement pstDates = null;
                            ResultSet rsDates = null;
                            PreparedStatement pstAtt = null;
                            ResultSet rsAtt = null;

                            try {
                               
                                String subSql = "SELECT DISTINCT s.Subject_ID, s.Subject_Name FROM Subjects s " +
                                                "JOIN Teacher_Allocation ta ON s.Subject_ID = ta.Subject_ID " +
                                                "WHERE ta.Class_ID = ?";
                                pstSubs = conn.prepareStatement(subSql);
                                pstSubs.setString(1, currentClass);
                                rsSubs = pstSubs.executeQuery();
                                while(rsSubs.next()) {
                                    subjects.add(new String[]{rsSubs.getString("Subject_ID"), rsSubs.getString("Subject_Name")});
                                }

                     
                                String dateSql = "SELECT DISTINCT TO_CHAR(" + dateCol + ", 'YYYY-MM-DD') as Att_Date " +
                                                 "FROM Attendance WHERE Student_ID = ? ORDER BY Att_Date DESC";
                                pstDates = conn.prepareStatement(dateSql);
                                pstDates.setString(1, sID);
                                rsDates = pstDates.executeQuery();
                                while(rsDates.next()) {
                                    String dStr = rsDates.getString("Att_Date");
                                    dates.add(dStr);
                                    attendanceMatrix.put(dStr, new HashMap<String, String>());
                                }

                               
                                String attSql = "";
                                if(hasSubjectId) {
                                    attSql = "SELECT TO_CHAR(" + dateCol + ", 'YYYY-MM-DD') as Att_Date, SUBJECT_ID, STATUS FROM Attendance WHERE Student_ID = ? ORDER BY RECORD_ID ASC";
                                } else if(hasSubId) {
                                    attSql = "SELECT TO_CHAR(" + dateCol + ", 'YYYY-MM-DD') as Att_Date, SUB_ID as SUBJECT_ID, STATUS FROM Attendance WHERE Student_ID = ? ORDER BY RECORD_ID ASC";
                                } else if(hasAllocId) {
                                    attSql = "SELECT TO_CHAR(a." + dateCol + ", 'YYYY-MM-DD') as Att_Date, ta.SUBJECT_ID, a.STATUS " +
                                             "FROM Attendance a " +
                                             "JOIN Teacher_Allocation ta ON a.ALLOC_ID = ta.ALLOC_ID " +
                                             "WHERE a.Student_ID = ? ORDER BY a.RECORD_ID ASC";
                                } else {
                                  
                                    attSql = "SELECT TO_CHAR(" + dateCol + ", 'YYYY-MM-DD') as Att_Date, 'ALL' as SUBJECT_ID, STATUS FROM Attendance WHERE Student_ID = ? ORDER BY RECORD_ID ASC";
                                }

                                pstAtt = conn.prepareStatement(attSql);
                                pstAtt.setString(1, sID);
                                rsAtt = pstAtt.executeQuery();
                                while(rsAtt.next()) {
                                    String dKey = rsAtt.getString("Att_Date");
                                    String subKey = rsAtt.getString("SUBJECT_ID");
                                    String statusVal = rsAtt.getString("STATUS");

                                    if(attendanceMatrix.containsKey(dKey)) {
                                        if("ALL".equalsIgnoreCase(subKey)) {
                                          
                                            boolean assigned = false;
                                            for(String[] sub : subjects) {
                                                if(!attendanceMatrix.get(dKey).containsKey(sub[0])) {
                                                    attendanceMatrix.get(dKey).put(sub[0], statusVal);
                                                    assigned = true;
                                                    break;
                                                }
                                            }
                                            if(!assigned && !subjects.isEmpty()) {
                                                attendanceMatrix.get(dKey).put(subjects.get(0)[0], statusVal);
                                            }
                                        } else {
                                            attendanceMatrix.get(dKey).put(subKey, statusVal);
                                        }
                                    }
                                }
                            } catch(Exception ex) {
                                out.println("<p style='color:red;'>Error mapping logic: " + ex.getMessage() + "</p>");
                            } finally {
                                if(rsAtt != null) { try { rsAtt.close(); } catch(Exception e) {} }
                                if(pstAtt != null) { try { pstAtt.close(); } catch(Exception e) {} }
                                if(rsDates != null) { try { rsDates.close(); } catch(Exception e) {} }
                                if(pstDates != null) { try { pstDates.close(); } catch(Exception e) {} }
                                if(rsSubs != null) { try { rsSubs.close(); } catch(Exception e) {} }
                                if(pstSubs != null) { try { pstSubs.close(); } catch(Exception e) {} }
                            }

                            if(dates.isEmpty() || subjects.isEmpty()) {
                        %>
                            <div style="text-align: center; padding: 20px; color: #64748b; font-style: italic;">
                                <i class="fas fa-calendar-times" style="font-size: 1.5rem; margin-bottom: 8px;"></i>
                                <p>No detailed attendance history found for this student.</p>
                            </div>
                        <%
                            } else {
                        %>
                            <table class="matrix-table">
                                <thead>
                                    <tr>
                                        <th style="text-align: left; padding: 10px 15px;">Date</th>
                                        <% for(String[] sub : subjects) { %>
                                            <th style="text-align: center; padding: 10px 15px;"><%= sub[1] %></th>
                                        <% } %>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for(String d : dates) { %>
                                        <tr>
                                            <td class="date-col" style="padding: 10px 15px;"><%= d %></td>
                                            <% 
                                                for(String[] sub : subjects) { 
                                                    String subID = sub[0];
                                                    String status = attendanceMatrix.get(d).get(subID);
                                                    if(status == null) {
                                            %>
                                                <td style="text-align: center; padding: 10px 15px;"><span class="badge-no-class">-</span></td>
                                            <% 
                                                    } else if(status.equalsIgnoreCase("Present")) { 
                                            %>
                                                <td style="text-align: center; padding: 10px 15px;"><span class="badge badge-present"><i class="fas fa-check"></i> Present</span></td>
                                            <% 
                                                    } else { 
                                            %>
                                                <td style="text-align: center; padding: 10px 15px;"><span class="badge badge-absent"><i class="fas fa-times"></i> Absent</span></td>
                                            <% 
                                                    }
                                                } 
                                            %>
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        <% } %>
                    </td>
                </tr>
                <%
                            }
                            if(!hasChildren) {
                %>
                <tr>
                    <td colspan="5" style="text-align:center; padding: 40px; color: #64748b;">
                        <i class="fas fa-user-slash" style="display:block; font-size: 2rem; margin-bottom: 10px; opacity: 0.5;"></i>
                        No student profiles linked to this account yet.
                    </td>
                </tr>
                <%
                            }
                        } catch(Exception e) {
                %>
                <tr>
                    <td colspan="5" style="color: #f87171; text-align: center;">Error: <%= e.getMessage() %></td>
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

<script>
function toggleTeachers(studentId) {
    var row = document.getElementById('teachers-row-' + studentId);
    var attRow = document.getElementById('attendance-row-' + studentId);
    
    if (row.style.display === 'none') {
        row.style.display = 'table-row';
        attRow.style.display = 'none';
    } else {
        row.style.display = 'none';
    }
}

function toggleAttendance(studentId) {
    var row = document.getElementById('attendance-row-' + studentId);
    var tRow = document.getElementById('teachers-row-' + studentId);
    
    if (row.style.display === 'none') {
        row.style.display = 'table-row';
        tRow.style.display = 'none';
    } else {
        row.style.display = 'none';
    }
}
</script>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>