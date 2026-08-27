<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ include file="dbConnect.jsp" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equalsIgnoreCase("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String tID = request.getParameter("teacherID");
    String currentPass = "";
    String currentName = "";
    String currentPhone = "";
    String currentAddress = "";

    if(conn != null && tID != null && !tID.trim().isEmpty()) {
        PreparedStatement pstUser = null;
        ResultSet rsUser = null;
        try {
            String sqlUser = "SELECT Password, Name, Phone, Address FROM Users WHERE UPPER(TRIM(User_ID)) = UPPER(TRIM(?))";
            pstUser = conn.prepareStatement(sqlUser);
            pstUser.setString(1, tID.trim());
            rsUser = pstUser.executeQuery();
            
            if(rsUser.next()) {
                currentPass = rsUser.getString("Password");
                currentName = rsUser.getString("Name");
                currentPhone = rsUser.getString("Phone");
                currentAddress = rsUser.getString("Address");
            } else {
                response.sendRedirect("manageTeachers.jsp");
                return;
            }
        } catch(Exception e) {
            out.println("<div style='color:#f87171; padding:20px; background:rgba(239,68,68,0.1); border:1px solid rgba(239,68,68,0.2); border-radius:12px; margin:20px; font-family:sans-serif;'>");
            out.println("<h3><i class='fas fa-exclamation-triangle'></i> Oracle Database Error</h3>");
            out.println("<p><b>Details:</b> " + e.getMessage() + "</p>");
            out.println("</div>");
            return;
        } finally {
            if(rsUser != null) { try { rsUser.close(); } catch(Exception e) {} }
            if(pstUser != null) { try { pstUser.close(); } catch(Exception e) {} }
        }
    } else {
        response.sendRedirect("manageTeachers.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Teacher - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: "Poppins", sans-serif; }
        body { background: radial-gradient(circle at center, #0d0d2b 0%, #050505 100%); color: #fff; min-height: 100vh; display: flex; align-items: center; justify-content: center; padding: 20px; }
        .edit-box { background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(15px); padding: 40px; border-radius: 24px; border: 1px solid rgba(139, 92, 246, 0.2); width: 100%; max-width: 480px; box-shadow: 0 20px 40px rgba(0,0,0,0.5); }
        h2 { color: #8b5cf6; margin-bottom: 25px; font-size: 1.6rem; display: flex; align-items: center; gap: 10px; }
        label { display: block; margin-bottom: 8px; color: #94a3b8; font-size: 0.85rem; font-weight: 600; }
        input[type="text"] { width: 100%; padding: 12px 16px; margin-bottom: 20px; background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 12px; color: white; outline: none; transition: 0.3s; font-size: 1rem; }
        input:focus { border-color: #8b5cf6; background: rgba(255, 255, 255, 0.08); }
        .btn-submit { width: 100%; padding: 14px; background: linear-gradient(135deg, #7c3aed, #8b5cf6); border: none; border-radius: 12px; color: white; font-weight: 600; cursor: pointer; transition: 0.3s; font-size: 1rem; }
        .btn-submit:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(139, 92, 246, 0.3); }
        .back-btn { display: block; text-align: center; margin-top: 20px; color: #94a3b8; text-decoration: none; font-size: 0.9rem; transition: 0.3s; }
        .back-btn:hover { color: #fff; }
    </style>
</head>
<body>

    <div class="edit-box">
        <h2><i class="fas fa-user-edit"></i> Edit Teacher Details</h2>
        <form action="updateTeacherProcess.jsp" method="POST">
            <input type="hidden" name="teacherID" value="<%= tID %>">
            
            <label><i class="fas fa-id-badge"></i> Teacher ID</label>
            <input type="text" value="<%= tID %>" disabled style="opacity: 0.5; cursor: not-allowed;">
            
            <label><i class="fas fa-key"></i> Password</label>
            <input type="text" name="password" value="<%= currentPass %>" required>
            
            <label><i class="fas fa-user"></i> Full Name</label>
            <input type="text" name="name" value="<%= currentName != null ? currentName : "" %>" required>
            
            <label><i class="fas fa-phone"></i> Phone Number</label>
            <input type="text" name="phone" value="<%= currentPhone != null ? currentPhone : "" %>">
            
            <label><i class="fas fa-map-marker-alt"></i> Address</label>
            <input type="text" name="address" value="<%= currentAddress != null ? currentAddress : "" %>">
            
            <button type="submit" class="btn-submit"><i class="fas fa-save"></i> Save All Changes</button>
        </form>
        
        <a href="manageTeachers.jsp" class="back-btn"><i class="fas fa-arrow-left"></i> Cancel & Go Back</a>
    </div>

</body>
</html>
<%
    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>