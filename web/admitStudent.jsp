<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Admission - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: "Segoe UI", Roboto, sans-serif;
            background: linear-gradient(135deg, #050505 0%, #0b0b20 50%, #1a1a3a 100%);
            color: #ffffff;
            height: 100vh; 
            width: 100vw;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden; 
            position: relative;
        }
        .particles-container { position: fixed; top: 0; left: 0; width: 100%; height: 100%; pointer-events: none; z-index: 1; }
        .p { position: absolute; background: rgba(0, 212, 255, 0.4); border-radius: 50%; animation: moveUp 10s infinite linear; }
        @keyframes moveUp {
            0% { transform: translateY(110vh) scale(0.5); opacity: 0; }
            50% { opacity: 0.7; }
            100% { transform: translateY(-10vh) scale(1.2); opacity: 0; }
        }
        .container { width: 100%; max-width: 480px; padding: 0 15px; z-index: 10; }
        .admission-card { 
            background: rgba(15, 23, 42, 0.75); 
            border: 1px solid rgba(255, 255, 255, 0.1); 
            border-radius: 20px; 
            padding: 25px 30px; 
            backdrop-filter: blur(20px); 
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5); 
        }
        .header-section { text-align: center; margin-bottom: 18px; }
        .header-section h2 { font-size: 1.6rem; background: linear-gradient(to right, #4facfe 0%, #00f2fe 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; margin-bottom: 4px; }
        .back-btn { text-decoration: none; color: #888; font-size: 0.85rem; transition: 0.3s; display: inline-flex; align-items: center; gap: 5px; }
        .back-btn:hover { color: #00f2fe; }
        
        .form-group { margin-bottom: 12px; } 
        .form-group label { display: block; color: #64a6fc; font-size: 0.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 5px; }
        
        input, select { width: 100%; padding: 10px 14px; background: rgba(30, 41, 59, 0.6); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 10px; color: #fff; font-size: 0.95rem; outline: none; transition: all 0.3s ease; }
        input:focus, select:focus { border-color: #00f2fe; background: rgba(45, 55, 75, 0.8); box-shadow: 0 0 12px rgba(0, 242, 254, 0.2); }
        select option { background: #0f172a; color: #fff; }
        
        .admit-btn { width: 100%; padding: 12px; margin-top: 10px; background: linear-gradient(to right, #00b09b, #96c93d); border: none; border-radius: 10px; color: white; font-size: 1rem; font-weight: bold; cursor: pointer; transition: 0.4s; text-transform: uppercase; letter-spacing: 1px; }
        .admit-btn:hover { transform: translateY(-2px); box-shadow: 0 8px 15px rgba(40, 167, 69, 0.3); filter: brightness(1.1); }
        ::placeholder { color: rgba(255,255,255,0.3); }
    </style>
</head>
<body>

    <div class="particles-container">
        <div class="p" style="width: 5px; height: 5px; left: 15%; animation-delay: 0s;"></div>
        <div class="p" style="width: 3px; height: 3px; left: 45%; animation-delay: 3s;"></div>
        <div class="p" style="width: 7px; height: 7px; left: 75%; animation-delay: 1s;"></div>
        <div class="p" style="width: 4px; height: 4px; left: 90%; animation-delay: 6s;"></div>
    </div>

    <div class="container">
        <div class="header-section">
            <h2>Student Admission</h2>
            <a href="adminHome.jsp" class="back-btn"><i class="fas fa-chevron-left"></i> Back to Dashboard</a>
        </div>

        <div class="admission-card">
            <form action="admitProcess.jsp" method="POST">
                
                <div class="form-group">
                    <label><i class="fas fa-id-card"></i> Student ID (Login ID)</label>
                    <input type="text" name="studentID" placeholder="e.g. Student205" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-lock"></i> Login Password</label>
                    <input type="password" name="password" placeholder="••••••••" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-user"></i> Full Name</label>
                    <input type="text" name="studentName" placeholder="Full name of student" required>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-chalkboard"></i> Assign to Class</label>
                    <select name="classID" required>
                        <option value="">-- Select Class --</option>
                        <%
                            if(conn != null) {
                                Statement st1 = conn.createStatement();
                                ResultSet rs1 = st1.executeQuery("SELECT Class_ID, Class_Name FROM Classes");
                                while(rs1.next()) {
                        %>
                            <option value="<%= rs1.getString("Class_ID") %>"> <%= rs1.getString("Class_Name") %> </option>
                        <%
                                }
                                st1.close();
                            }
                        %>
                    </select>
                </div>

                <div class="form-group">
                    <label><i class="fas fa-users-cog"></i> Link to Guardian</label>
                    <select name="guardianID" required>
                        <option value="">-- Select Guardian --</option>
                        <%
                            if(conn != null) {
                                Statement st2 = conn.createStatement();
                                ResultSet rs2 = st2.executeQuery("SELECT User_ID, Name FROM Users WHERE UPPER(TRIM(User_Role)) = 'GUARDIAN' OR User_ID LIKE 'Guardian%'");
                                while(rs2.next()) {
                                    String gIDOption = rs2.getString("User_ID");
                                    String gNameOption = rs2.getString("Name") != null ? rs2.getString("Name") : "No Name Set";
                        %>
                            <option value="<%= gIDOption %>"> <%= gIDOption %> (<%= gNameOption %>) </option>
                        <%
                                }
                                st2.close();
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label><i class="fas fa-tint" style="color: #ff4d4d;"></i> Blood Group</label>
                    <select name="bloodGroup" required>
                        <option value="">-- Select Blood Group --</option>
                        <option value="A+">A+</option>
                        <option value="A-">A-</option>
                        <option value="B+">B+</option>
                        <option value="B-">B-</option>
                        <option value="AB+">AB+</option>
                        <option value="AB-">AB-</option>
                        <option value="O+">O+</option>
                        <option value="O-">O-</option>
                    </select>
                </div>

                <button type="submit" class="admit-btn">
                    <i class="fas fa-user-plus"></i> Admit Student
                </button>
            </form>
        </div>
    </div>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>