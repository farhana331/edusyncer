<%@page contentType="text/html" pageEncoding="UTF-8" import="java.sql.*"%>
<%@ include file="dbConnect.jsp" %>
<%
   
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String tID = request.getParameter("teacherID");
    
    if(conn != null && tID != null && !tID.trim().isEmpty()) {
        PreparedStatement psAlloc = null;
        PreparedStatement psUser = null;
        try {
           
            conn.setAutoCommit(false);
            
            String deleteAllocSQL = "DELETE FROM Teacher_Allocation WHERE Teacher_ID = ?";
            psAlloc = conn.prepareStatement(deleteAllocSQL);
            psAlloc.setString(1, tID);
            psAlloc.executeUpdate();
            
            String deleteUserSQL = "DELETE FROM Users WHERE User_ID = ? AND User_Role = 'Teacher'";
            psUser = conn.prepareStatement(deleteUserSQL);
            psUser.setString(1, tID);
            psUser.executeUpdate();
            conn.commit();
           
            response.sendRedirect("manageTeachers.jsp");
            
        } catch(Exception e) {
          
            if(conn != null) {
                try { conn.rollback(); } catch(SQLException ex) { }
            }
            out.println("<html><body style='background:#0f172a; color:#f87171; padding:30px; font-family:sans-serif;'>");
            out.println("<h2><i class='fas fa-exclamation-triangle'></i> Database Rollback Error:</h2>");
            out.println("<p>" + e.getMessage() + "</p>");
            out.println("<br><a href='manageTeachers.jsp' style='color:#38bdf8; text-decoration:none;'>Back to List</a>");
            out.println("</body></html>");
        } finally {
            if(psAlloc != null) psAlloc.close();
            if(psUser != null) psUser.close();
        }
    } else {
        response.sendRedirect("manageTeachers.jsp");
    }
%>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>