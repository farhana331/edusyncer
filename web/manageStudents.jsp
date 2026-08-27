<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String searchID = request.getParameter("searchID");
    String filterClass = request.getParameter("filterClass");
    String deleteID = request.getParameter("deleteID");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Students - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Poppins", sans-serif; }
        body { background: radial-gradient(circle at center, #0d0d2b 0%, #050505 100%); color: #fff; min-height: 100vh; padding: 40px 20px; position: relative; }
        .container { max-width: 1250px; margin: 0 auto; background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(15px); border-radius: 20px; border: 1px solid rgba(255, 255, 255, 0.1); padding: 30px; box-shadow: 0 15px 35px rgba(0,0,0,0.5); }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .header h2 { color: #f59e0b; font-size: 1.8rem; }
        .back-link { color: #00d4ff; text-decoration: none; font-weight: bold; transition: 0.3s; }
        .back-link:hover { color: #fff; transform: translateX(-5px); }
        .filter-bar { display: flex; gap: 15px; margin-bottom: 30px; background: rgba(0,0,0,0.3); padding: 15px; border-radius: 15px; }
        .filter-bar input, .filter-bar select { flex: 1; padding: 10px 15px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 8px; color: #fff; outline: none; }
        .filter-bar input:focus, .filter-bar select:focus { border-color: #f59e0b; }
        .filter-bar select option { background-color: #111827; color: #ffffff; padding: 10px; }
        .filter-bar button { padding: 10px 25px; background: #f59e0b; color: #fff; border: none; border-radius: 8px; font-weight: bold; cursor: pointer; transition: 0.3s; }
        .filter-bar button:hover { background: #d97706; }
        .clear-btn { padding: 10px 20px; background: #475569; color: #fff; text-decoration: none; border-radius: 8px; font-weight: bold; display: flex; align-items: center; transition: 0.3s; }
        .clear-btn:hover { background: #64748b; }
        table { width: 100%; border-collapse: collapse; }
        th { background: rgba(245, 158, 11, 0.1); color: #fcd34d; text-align: left; padding: 15px; font-size: 0.85rem; text-transform: uppercase; border-bottom: 2px solid rgba(245, 158, 11, 0.2); }
        td { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.05); color: #cbd5e1; font-size: 0.9rem; }
        tr:hover { background: rgba(255,255,255,0.02); }
        .action-btn { padding: 6px 10px; border-radius: 6px; text-decoration: none; font-size: 0.8rem; font-weight: bold; margin-right: 5px; transition: 0.3s; display: inline-block; }
        .btn-edit { background: rgba(56, 189, 248, 0.1); color: #38bdf8; border: 1px solid rgba(56, 189, 248, 0.2); }
        .btn-edit:hover { background: #38bdf8; color: #000; }
        .btn-delete { background: rgba(239, 68, 68, 0.1); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.2); }
        .btn-delete:hover { background: #ef4444; color: #fff; }
        .g-info { font-size: 0.82rem; color: #94a3b8; display: block; margin-top: 2px; }
        .g-info i { width: 14px; margin-right: 4px; color: #38bdf8; }

       
        .modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(2, 6, 23, 0.75);
            backdrop-filter: blur(8px);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            animation: fadeIn 0.2s ease-out;
        }

        .modal-card {
            background: rgba(15, 23, 42, 0.95);
            border: 1px solid rgba(239, 68, 68, 0.3);
            border-radius: 20px;
            padding: 30px;
            width: 100%;
            max-width: 420px;
            text-align: center;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.7);
            animation: scaleUp 0.25s ease-out;
        }

        .modal-icon {
            font-size: 3rem;
            color: #f87171;
            margin-bottom: 15px;
        }

        .modal-card h3 {
            font-size: 1.3rem;
            margin-bottom: 10px;
            color: #fff;
        }

        .modal-card p {
            color: #94a3b8;
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 25px;
        }

        .modal-buttons {
            display: flex;
            gap: 12px;
            justify-content: center;
        }

        .modal-btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.9rem;
            cursor: pointer;
            text-decoration: none;
            transition: 0.2s;
            border: none;
        }

        .btn-cancel {
            background: rgba(255, 255, 255, 0.05);
            color: #cbd5e1;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        .btn-cancel:hover { background: rgba(255, 255, 255, 0.1); color: #fff; }

        .btn-confirm-delete {
            background: #ef4444;
            color: #fff;
        }
        .btn-confirm-delete:hover { background: #dc2626; }

        @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
        @keyframes scaleUp { from { transform: scale(0.9); opacity: 0; } to { transform: scale(1); opacity: 1; } }
    </style>
</head>
<body>

<% if(deleteID != null && !deleteID.trim().isEmpty()) { %>
    <div class="modal-overlay">
        <div class="modal-card">
            <div class="modal-icon"><i class="fas fa-exclamation-triangle"></i></div>
            <h3>Are you sure?</h3>
            <p>DANGER: This will delete Student <b><%= deleteID %></b>, their Guardian, and all related information. This cannot be undone!</p>
            <div class="modal-buttons">
                <% 
                    String cancelUrl = "manageStudents.jsp?";
                    if(searchID != null && !searchID.trim().isEmpty()) cancelUrl += "searchID=" + searchID + "&";
                    if(filterClass != null && !filterClass.trim().isEmpty()) cancelUrl += "filterClass=" + filterClass;
                %>
                <a href="<%= cancelUrl %>" class="modal-btn btn-cancel">Cancel</a>
                <a href="deleteStudentProcess.jsp?studentID=<%= deleteID %>" class="modal-btn btn-confirm-delete">Yes, Delete</a>
            </div>
        </div>
    </div>
<% } %>

<div class="container">
    <div class="header">
        <h2><i class="fas fa-users-cog"></i> Manage Students</h2>
        <a href="adminHome.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </div>
    <form action="manageStudents.jsp" method="GET" class="filter-bar">
        <input type="text" name="searchID" placeholder="Search by Student ID..." value="<%= searchID != null ? searchID : "" %>">
        <select name="filterClass">
            <option value="">-- Filter by Class --</option>
            <%
                if(conn != null) {
                    Statement stClass = null;
                    ResultSet rsClass = null;
                    try {
                        stClass = conn.createStatement();
                        rsClass = stClass.executeQuery("SELECT Class_ID, Class_Name FROM Classes ORDER BY Class_Name ASC");
                        while(rsClass.next()) {
                            String cID = rsClass.getString("Class_ID");
                            String selected = (filterClass != null && filterClass.equals(cID)) ? "selected" : "";
                            out.println("<option value='"+cID+"' "+selected+">"+rsClass.getString("Class_Name")+"</option>");
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    } finally {
                        if(rsClass != null) rsClass.close();
                        if(stClass != null) stClass.close();
                    }
                }
            %>
        </select>
        <button type="submit"><i class="fas fa-search"></i> Search</button>
        <a href="manageStudents.jsp" class="clear-btn">Clear</a>
    </form>
    <table>
        <thead>
            <tr>
                <th>Student ID</th>
                <th>Full Name</th>
                <th>Class</th>
                <th>Blood Group</th> 
                <th>Guardian Details</th> 
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <%
                if(conn != null) {
                    Statement st = null;
                    ResultSet rs = null;
                    try {
                        String sql = "SELECT s.Student_ID, s.Student_Name, s.Class_ID, s.Blood_Group, s.Guardian_ID, " +
                                     "g.Name AS Guardian_Name, g.Phone AS Guardian_Phone, g.Address AS Guardian_Address, g.Gender AS Guardian_Gender " +
                                     "FROM Students s " +
                                     "LEFT JOIN Users g ON s.Guardian_ID = g.User_ID " +
                                     "WHERE 1=1";
                        if(searchID != null && !searchID.trim().isEmpty()) {
                            sql += " AND s.Student_ID = '" + searchID.trim() + "'";
                        }
                        if(filterClass != null && !filterClass.trim().isEmpty()) {
                            sql += " AND s.Class_ID = '" + filterClass.trim() + "'";
                        }
                        sql += " ORDER BY s.Student_ID ASC";
                        st = conn.createStatement();
                        rs = st.executeQuery(sql);
                        boolean hasData = false;
                        while(rs.next()) {
                            hasData = true;
                            String sID = rs.getString("Student_ID");
                            String gID = rs.getString("Guardian_ID");
                            String gName = rs.getString("Guardian_Name");
                            String gPhone = rs.getString("Guardian_Phone");
                            String gAddress = rs.getString("Guardian_Address");
                            String gGender = rs.getString("Guardian_Gender");
            %>
                            <tr>
                                <td style="color: #fff; font-weight: bold;"><%= sID %></td>
                                <td><%= rs.getString("Student_Name") %></td>
                                <td><span style="background: rgba(255,255,255,0.1); padding: 4px 8px; border-radius: 4px;"><%= rs.getString("Class_ID") %></span></td>
                                <td><span style="color: #ff4d4d; font-weight: bold; background: rgba(255, 77, 77, 0.1); padding: 3px 8px; border-radius: 5px; border: 1px solid rgba(255, 77, 77, 0.3);"><i class="fas fa-tint"></i> <%= rs.getString("Blood_Group") != null ? rs.getString("Blood_Group") : "N/A" %></span></td>
                                <td>
                                    <span style="font-weight: 600; color: #f59e0b;"><%= gID != null ? gID : "N/A" %></span>
                                    <span class="g-info"><i class="fas fa-user"></i> <%= gName != null ? gName : "N/A" %></span>
                                    <span class="g-info">
                                        <% 
                                            if (gGender != null && !gGender.trim().isEmpty()) {
                                                String norm = gGender.trim().toLowerCase();
                                                if (norm.equals("male") || norm.equals("m")) { %>
                                                    <i class="fas fa-mars" style="color: #38bdf8;"></i> Male
                                                <% } else if (norm.equals("female") || norm.equals("f")) { %>
                                                    <i class="fas fa-venus" style="color: #f43f5e;"></i> Female
                                                <% } else { %>
                                                    <i class="fas fa-genderless" style="color: #a855f7;"></i> <%= gGender %>
                                                <% }
                                            } else { %>
                                                <i class="fas fa-genderless" style="color: #a855f7;"></i> N/A
                                            <% } %>
                                    </span>
                                    <span class="g-info"><i class="fas fa-phone"></i> <%= gPhone != null ? gPhone : "N/A" %></span>
                                    <span class="g-info"><i class="fas fa-map-marker-alt"></i> <%= gAddress != null ? gAddress : "N/A" %></span>
                                </td>
                                <td>
                                    <a href="updateStudent.jsp?studentID=<%= sID %>" class="action-btn btn-edit"><i class="fas fa-edit"></i> Edit</a>
                                    <% 
                                        String deleteUrl = "manageStudents.jsp?";
                                        if(searchID != null && !searchID.trim().isEmpty()) deleteUrl += "searchID=" + searchID + "&";
                                        if(filterClass != null && !filterClass.trim().isEmpty()) deleteUrl += "filterClass=" + filterClass + "&";
                                        deleteUrl += "deleteID=" + sID;
                                    %>
                                    <a href="<%= deleteUrl %>" class="action-btn btn-delete">
                                       <i class="fas fa-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
            <%
                        }
                        if(!hasData) {
                            out.println("<tr><td colspan='6' style='text-align:center; padding: 30px; color: #64748b;'>No students found matching your criteria.</td></tr>");
                        }
                    } catch(Exception e) {
                        out.println("<tr><td colspan='6' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if(rs != null) rs.close();
                        if(st != null) st.close();
                    }
                }
            %>
        </tbody>
    </table>
</div>
</body>
</html>
<%
    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>