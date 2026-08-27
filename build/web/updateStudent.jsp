<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    String studentID = request.getParameter("studentID");
    String sName = "", cID = "", gID = "", bg = "";

    if(conn != null && studentID != null) {
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            pst = conn.prepareStatement("SELECT Student_Name, Class_ID, Guardian_ID, Blood_Group FROM Students WHERE Student_ID = ?");
            pst.setString(1, studentID);
            rs = pst.executeQuery();
            if(rs.next()) {
                sName = rs.getString("Student_Name");
                cID = rs.getString("Class_ID");
                gID = rs.getString("Guardian_ID");
                bg = rs.getString("Blood_Group");
            }
        } catch(Exception e) {
            System.out.println("Error: " + e.getMessage());
        } finally {
            if(rs != null) {
                try { rs.close(); } catch(Exception e) { System.out.println("Error closing ResultSet: " + e.getMessage()); }
            }
            if(pst != null) {
                try { pst.close(); } catch(Exception e) { System.out.println("Error closing PreparedStatement: " + e.getMessage()); }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update Student</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: "Poppins", sans-serif; }
        body {
            background: radial-gradient(circle at center, #0d0d2b 0%, #050505 100%); 
            color: #fff; 
            display: flex; 
            justify-content: center; 
            align-items: center; 
            min-height: 100vh; }
        .card { 
            background: rgba(15, 23, 42, 0.8); 
            backdrop-filter: blur(20px); 
            border: 1px solid rgba(255,255,255,0.1); 
            padding: 40px; 
            border-radius: 20px; 
            width: 100%; 
            max-width: 450px; 
            box-shadow: 0 20px 50px rgba(0,0,0,0.5); }
        h2 { 
            color: #38bdf8; 
            margin-bottom: 25px; 
            text-align: center; }
        label { 
            display: block; 
            color: #64a6fc; 
            font-size: 0.85rem; 
            font-weight: bold; 
            margin-bottom: 8px; 
            text-transform: uppercase; }
        input, select { 
            width: 100%; 
            padding: 12px; 
            background: rgba(0,0,0,0.3); 
            border: 1px solid rgba(255,255,255,0.1); 
            border-radius: 8px; 
            color: #fff; 
            margin-bottom: 20px; 
            outline: none; 
            transition: 0.3s; }
        input:focus, select:focus { border-color: #38bdf8; }
        select option { 
            background: #0f172a; 
            color: #fff; }
        .readonly { 
            background: rgba(255,255,255,0.02); 
            color: #888; }
        .btn-update { 
            width: 100%; 
            padding: 14px; 
            background: linear-gradient(90deg, #006eff, #00d4ff); 
            border: none; 
            color: white; 
            font-weight: bold; 
            border-radius: 8px; 
            cursor: pointer; 
            transition: 0.3s; 
            margin-top: 10px; }
        .btn-update:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 5px 15px rgba(0, 212, 255, 0.4); }
        .back-link { 
            display: block; 
            text-align: center; 
            margin-top: 20px; 
            color: #aaa; 
            text-decoration: none; 
            font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="card">
        <h2><i class="fas fa-user-edit"></i> Edit Student</h2>
        
        <% if(conn == null) { %>
            <h3 style="color: #f87171; text-align: center; margin-bottom: 20px;">Database Connection Lost!<br>Please restart your server.</h3>
            <a href="manageStudents.jsp" class="back-link">Go Back</a>
        <% } else { %>
        
        <form action="updateStudentProcess.jsp" method="POST">
            <label>Student ID (Cannot be changed)</label>
            <input type="text" name="studentID" value="<%= studentID %>" class="readonly" readonly>

            <label>Full Name</label>
            <input type="text" name="studentName" value="<%= sName %>" required>

            <label>Update Class</label>
            <select name="classID" required>
                <%
                    try {
                        Statement stC = conn.createStatement();
                        ResultSet rsC = stC.executeQuery("SELECT Class_ID, Class_Name FROM Classes");
                        while(rsC.next()) {
                            String selected = rsC.getString("Class_ID").equals(cID) ? "selected" : "";
                            out.println("<option value='"+rsC.getString("Class_ID")+"' "+selected+">"+rsC.getString("Class_Name")+"</option>");
                        }
                        rsC.close();
                        stC.close();
                    } catch(Exception e) {}
                %>
            </select>

            <label>Update Guardian</label>
            <select name="guardianID" required>
                <%
                    try {
                        Statement stG = conn.createStatement();
                        ResultSet rsG = stG.executeQuery("SELECT User_ID FROM Users WHERE User_Role='Guardian'");
                        while(rsG.next()) {
                            String selected = rsG.getString("User_ID").equals(gID) ? "selected" : "";
                            out.println("<option value='"+rsG.getString("User_ID")+"' "+selected+">"+rsG.getString("User_ID")+"</option>");
                        }
                        rsG.close();
                        stG.close();
                    } catch(Exception e) {}
                %>
            </select>

            <label>Update Blood Group</label>
            <select name="bloodGroup" required>
                <option value="A+" <%= "A+".equals(bg) ? "selected" : "" %>>A+</option>
                <option value="A-" <%= "A-".equals(bg) ? "selected" : "" %>>A-</option>
                <option value="B+" <%= "B+".equals(bg) ? "selected" : "" %>>B+</option>
                <option value="B-" <%= "B-".equals(bg) ? "selected" : "" %>>B-</option>
                <option value="AB+" <%= "AB+".equals(bg) ? "selected" : "" %>>AB+</option>
                <option value="AB-" <%= "AB-".equals(bg) ? "selected" : "" %>>AB-</option>
                <option value="O+" <%= "O+".equals(bg) ? "selected" : "" %>>O+</option>
                <option value="O-" <%= "O-".equals(bg) ? "selected" : "" %>>O-</option>
            </select>

            <button type="submit" class="btn-update">Save Changes</button>
        </form>
        <a href="manageStudents.jsp" class="back-link">Cancel and Go Back</a>
        <% } %>
    </div>
</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>