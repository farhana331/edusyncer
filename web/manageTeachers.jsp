<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%@page import="java.sql.*" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
    String searchID = request.getParameter("searchID");
    String deleteID = request.getParameter("deleteID");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Teachers - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Poppins", sans-serif; }
        
        body { 
            background: radial-gradient(circle at center, #0d0d2b 0%, #050505 100%); 
            color: #fff; 
            min-height: 100vh; 
            padding: 40px 20px; 
            position: relative;
        }

        .container { 
            max-width: 1300px; 
            margin: 0 auto; 
            background: rgba(15, 23, 42, 0.7); 
            backdrop-filter: blur(15px); 
            border-radius: 20px; 
            border: 1px solid rgba(255, 255, 255, 0.1); 
            padding: 30px; 
            box-shadow: 0 15px 35px rgba(0,0,0,0.5); 
        }

        .header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 25px; 
        }

        .header h2 { color: #8b5cf6; font-size: 1.8rem; }
        
        .back-link { 
            color: #38bdf8; 
            text-decoration: none; 
            font-weight: bold; 
            transition: 0.3s; 
        }
        .back-link:hover { color: #fff; transform: translateX(-5px); }
        
        .filter-bar { 
            display: flex; 
            gap: 15px; 
            margin-bottom: 30px; 
            background: rgba(0,0,0,0.3); 
            padding: 15px; 
            border-radius: 15px; 
        }
        .filter-bar input { 
            flex: 1; 
            padding: 12px 15px; 
            background: rgba(255,255,255,0.05); 
            border: 1px solid rgba(255,255,255,0.1); 
            border-radius: 8px; 
            color: #fff; 
            outline: none; 
        }
        .filter-bar button { 
            padding: 10px 25px; 
            background: #8b5cf6; 
            color: #fff; 
            border: none; 
            border-radius: 8px; 
            font-weight: bold; 
            cursor: pointer; 
            transition: 0.3s; 
        }
        .filter-bar button:hover { background: #7c3aed; }

        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { 
            background: rgba(139, 92, 246, 0.1); 
            color: #c4b5fd; 
            text-align: left; 
            padding: 15px; 
            font-size: 0.85rem; 
            text-transform: uppercase; 
            border-bottom: 2px solid rgba(139, 92, 246, 0.2); 
        }
        td { padding: 15px; border-bottom: 1px solid rgba(255,255,255,0.05); color: #cbd5e1; font-size: 0.95rem; vertical-align: middle; }
        tr:hover { background: rgba(255,255,255,0.02); }
        
        td:nth-child(3), td:nth-child(4) { white-space: nowrap; }
        td:nth-child(5) { max-width: 280px; }
        
        .tag { 
            background: rgba(139, 92, 246, 0.15); 
            padding: 6px 12px; 
            border-radius: 6px; 
            font-size: 0.8rem; 
            margin-right: 6px; 
            border: 1px solid rgba(139, 92, 246, 0.3); 
            color: #a5b4fc; 
            display: inline-flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 6px; 
            white-space: nowrap;
        }

        td:last-child { display: flex; flex-direction: column; gap: 8px; border-bottom: none; width: max-content; }

        .action-btn { 
            padding: 8px 15px; 
            border-radius: 8px; 
            text-decoration: none; 
            font-size: 0.85rem; 
            font-weight: 600; 
            margin-right: 0; 
            transition: 0.3s; 
            display: inline-flex; 
            align-items: center;
            justify-content: center;
            gap: 6px;
            width: 95px;
        }
        .btn-edit { 
            background: rgba(56, 189, 248, 0.1); 
            color: #38bdf8; 
            border: 1px solid rgba(56, 189, 248, 0.3); 
        }
        .btn-edit:hover { background: #38bdf8; color: #000; }
        
        .btn-delete { 
            background: rgba(239, 68, 68, 0.1); 
            color: #f87171; 
            border: 1px solid rgba(239, 68, 68, 0.3); 
            cursor: pointer;
        }
        .btn-delete:hover { background: #ef4444; color: #fff; }

        .t-info { font-size: 0.82rem; color: #94a3b8; display: block; margin-top: 4px; }
        .t-info i { width: 14px; margin-right: 4px; }

        /* Custom Confirmation Modal Overlay */
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
            <p>This will permanently delete teacher <b><%= deleteID %></b> and all their associated classroom records. Proceed?</p>
            <div class="modal-buttons">
                <a href="manageTeachers.jsp<%= searchID != null && !searchID.trim().isEmpty() ? "?searchID=" + searchID : "" %>" class="modal-btn btn-cancel">Cancel</a>
                <a href="deleteTeacherProcess.jsp?teacherID=<%= deleteID %>" class="modal-btn btn-confirm-delete">Yes, Delete</a>
            </div>
        </div>
    </div>
<% } %>

<div class="container">
    <div class="header">
        <h2><i class="fas fa-user-tie"></i> Manage Teachers</h2>
        <a href="adminHome.jsp" class="back-link"><i class="fas fa-arrow-left"></i> Back to Dashboard</a>
    </div>

    <form action="manageTeachers.jsp" method="GET" class="filter-bar">
        <input type="text" name="searchID" placeholder="Search by Teacher ID..." value="<%= searchID != null ? searchID : "" %>">
        <button type="submit"><i class="fas fa-search"></i> Search</button>
        <a href="manageTeachers.jsp" style="color: #94a3b8; text-decoration: none; padding: 10px;">Clear</a>
    </form>

    <table>
        <thead>
            <tr>
                <th>Teacher ID</th>
                <th>Teacher Details</th>
                <th>Phone Number</th>
                <th>Address</th> 
                <th>Assigned Classes & Subjects</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
           <%
    if(conn != null) {
        Statement st = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT u.*, " +
                         "(SELECT LISTAGG(ta.Class_ID || ' (' || ta.Subject_ID || ')', ', ') " +
                         " WITHIN GROUP (ORDER BY ta.Class_ID) " +
                         " FROM Teacher_Allocation ta WHERE UPPER(TRIM(ta.Teacher_ID)) = UPPER(TRIM(u.User_ID))) as Assignments " +
                         "FROM Users u " +
                         "WHERE UPPER(TRIM(u.User_Role)) = 'TEACHER' ";

            if(searchID != null && !searchID.trim().isEmpty()) {
                sql += "AND LOWER(u.User_ID) LIKE LOWER('%" + searchID.trim() + "%') ";
            }

            sql += "ORDER BY u.User_ID";

            st = conn.createStatement();
            rs = st.executeQuery(sql);
            
            boolean hasData = false;
            while(rs.next()) {
                hasData = true;
               
                String tID = rs.getString("User_ID");
                String assignments = rs.getString("Assignments");
                String tName = rs.getString("Name");
                String tPhone = rs.getString("Phone");
                String tAddress = rs.getString("Address");
                String tGender = rs.getString("Gender");
              
                if(tName == null) tName = "N/A";
                if(tPhone == null) tPhone = "N/A";
                if(tAddress == null) tAddress = "N/A";
%>
                <tr>
                    <td style="font-weight: 600; color: #fff;"><%= tID %></td>
                    <td>
                        <span style="color: #38bdf8; font-weight: 500; display: block;"><%= tName %></span>
                        
                        <span class="t-info">
                            <% 
                                if (tGender != null && !tGender.trim().isEmpty()) {
                                    String normalizedGender = tGender.trim().toLowerCase();
                                    if (normalizedGender.equals("male") || normalizedGender.equals("m")) { 
                            %>
                                        <i class="fas fa-mars" style="color: #38bdf8;"></i> Male
                            <% 
                                    } else if (normalizedGender.equals("female") || normalizedGender.equals("f")) { 
                            %>
                                        <i class="fas fa-venus" style="color: #f43f5e;"></i> Female
                            <% 
                                    } else { 
                            %>
                                        <i class="fas fa-genderless" style="color: #a855f7;"></i> <%= tGender %>
                            <% 
                                    }
                                } else { 
                            %>
                                    <i class="fas fa-genderless" style="color: #a855f7;"></i> N/A
                            <% 
                                } 
                            %>
                        </span>
                    </td>
                    <td><i class="fas fa-phone-alt" style="font-size: 0.8rem; color: #64748b; margin-right: 5px;"></i> <%= tPhone %></td>
                    
                    <td><i class="fas fa-map-marker-alt" style="font-size: 0.8rem; color: #64748b; margin-right: 5px;"></i> <%= tAddress %></td>
                    
                    <td>
                        <% 
                            if(assignments != null && !assignments.trim().isEmpty()) { 
                                String[] parts = assignments.split(", ");
                                for(String p : parts) {
                        %>
                                    <span class="tag"><i class="fas fa-chalkboard"></i> <%= p %></span>
                        <% 
                                } 
                            } else { 
                        %>
                                    <span style="color: #64748b; font-style: italic;">No allocation found</span>
                        <% } %>
                    </td>
                    <td>
                        <a href="editTeacher.jsp?teacherID=<%= tID %>" class="action-btn btn-edit">
                            <i class="fas fa-edit"></i> Edit
                        </a>
                        <a href="manageTeachers.jsp?<%= searchID != null && !searchID.trim().isEmpty() ? "searchID=" + searchID + "&" : "" %>deleteID=<%= tID %>" class="action-btn btn-delete">
                            <i class="fas fa-trash"></i> Delete
                        </a>
                    </td>
                </tr>
<%
            }
            if(!hasData) {
                out.println("<tr><td colspan='6' style='text-align:center; padding: 40px; color: #64748b;'>No teachers found in the database.</td></tr>");
            }
        } catch(Exception e) {
            out.println("<tr><td colspan='6' style='color:#f87171; padding: 20px;'><b>Error loading data:</b> " + e.getMessage() + "</td></tr>");
        } finally {
            
            if(rs != null) { try { rs.close(); } catch(Exception e) {} }
            if(st != null) { try { st.close(); } catch(Exception e) {} }
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