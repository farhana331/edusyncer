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
    <title>Allocate Teacher - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Arial", sans-serif;
            background: linear-gradient(to right bottom, #0a0a0a 0%, #0b0b20 50%, #16213e 100%);
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }

        
        .floating-particles {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            pointer-events: none; z-index: 1;
        }

        .particle {
            position: absolute;
            width: 4px; height: 4px;
            background: rgba(0, 213, 255, 0.6);
            border-radius: 50%;
            animation: floatParticle 8s infinite linear;
        }

        @keyframes floatParticle {
            0% { transform: translateY(100vh) translateX(0); opacity: 0; }
            50% { opacity: 0.8; }
            100% { transform: translateY(-10vh) translateX(50px); opacity: 0; }
        }

      
        .bg-orb {
            position: fixed;
            width: 450px; height: 450px;
            background: radial-gradient(circle, rgba(134, 142, 255, 0.15), transparent 70%);
            border-radius: 50%;
            z-index: 0;
        }

        .container {
            width: 90%;
            max-width: 850px;
            z-index: 10;
            position: relative;
        }

       
        .allocation-card {
            display: flex;
            background: rgba(15, 23, 42, 0.8);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 25px;
            overflow: hidden;
            backdrop-filter: blur(20px);
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.6);
        }

       
        .info-sidebar {
            background: linear-gradient(135deg, rgba(0, 110, 255, 0.2), rgba(0, 17, 51, 0.8));
            width: 35%;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            border-right: 1px solid rgba(255, 255, 255, 0.05);
        }

        .info-sidebar i {
            font-size: 3.5rem;
            color: #00d4ff;
            margin-bottom: 20px;
            filter: drop-shadow(0 0 15px rgba(0, 212, 255, 0.5));
        }

        .info-sidebar h2 {
            font-size: 1.5rem;
            background: linear-gradient(to right, #fff, #bce3fd);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

      
        .form-content {
            flex: 1;
            padding: 45px;
        }

        .back-nav { margin-bottom: 20px; }
        .back-nav a { color: #888; text-decoration: none; font-size: 0.9rem; transition: 0.3s; }
        .back-nav a:hover { color: #00d4ff; }

        .input-group { margin-bottom: 22px; }
        .input-group label {
            display: block; color: #64a6fc; font-size: 0.85rem;
            margin-bottom: 8px; font-weight: bold; text-transform: uppercase;
        }

        select {
            width: 100%; padding: 12px 15px;
            background: rgba(30, 41, 59, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: #fff; font-size: 1rem; outline: none;
            transition: all 0.3s ease; cursor: pointer;
        }

        select:focus { border-color: #00d4ff; box-shadow: 0 0 15px rgba(0, 212, 255, 0.2); }

        .assign-btn {
            width: 100%; padding: 15px;
            background: linear-gradient(to right, #006eff, #00b1c9);
            border: none; border-radius: 12px;
            color: white; font-size: 1.1rem; font-weight: bold;
            cursor: pointer; transition: 0.3s;
            display: flex; align-items: center; justify-content: center; gap: 10px;
        }

        .assign-btn:hover { transform: translateY(-3px); box-shadow: 0 10px 25px rgba(0, 212, 255, 0.4); }

        @media (max-width: 768px) {
            .allocation-card { flex-direction: column; }
            .info-sidebar { width: 100%; padding: 30px; }
        }
    </style>
</head>
<body>

    <div class="floating-particles">
        <div class="particle" style="left: 10%; animation-delay: 0s;"></div>
        <div class="particle" style="left: 30%; animation-delay: 2s; width: 2px; height: 2px;"></div>
        <div class="particle" style="left: 50%; animation-delay: 4s;"></div>
        <div class="particle" style="left: 70%; animation-delay: 1s; width: 6px; height: 6px;"></div>
        <div class="particle" style="left: 90%; animation-delay: 5s;"></div>
    </div>

    <div class="bg-orb" style="top: -100px; left: -100px;"></div>
    <div class="bg-orb" style="bottom: -100px; right: -100px; background: radial-gradient(circle, rgba(187, 121, 250, 0.1), transparent 70%);"></div>

    <div class="container">
        <div class="back-nav">
            <a href="adminHome.jsp"><i class="fas fa-chevron-left"></i> Back to Dashboard</a>
        </div>

        <div class="allocation-card">
            <div class="info-sidebar">
                <i class="fas fa-network-wired"></i>
                <h2>Teacher Allocation</h2>
                <p style="font-size: 0.85rem; color: #888; margin-top: 10px;">Link experts to their respective classes and subjects.</p>
            </div>

            <div class="form-content">
                <form action="allocateProcess.jsp" method="POST">
                    
                    <div class="input-group">
                        <label>Select Teacher</label>
                        <select name="teacherID" required>
                            <option value="">-- Choose a Teacher --</option>
                            <%
                                if(conn != null) {
                                    try {
                                        Statement st1 = conn.createStatement();
                                        ResultSet rs1 = st1.executeQuery("SELECT User_ID FROM Users WHERE User_Role = 'Teacher' ORDER BY REGEXP_SUBSTR(User_ID, '[0-9]+') + 0 ASC, User_ID ASC");
                                        while(rs1.next()) {
                            %>
                                <option value="<%= rs1.getString("User_ID") %>"><%= rs1.getString("User_ID") %></option>
                            <%
                                        }
                                        rs1.close();
                                        st1.close();
                                    } catch(Exception e) {
                                        out.println("<option value=''>Error loading teachers</option>");
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="input-group">
                        <label>Select Class</label>
                        <select name="classID" required>
                            <option value="">-- Choose a Class --</option>
                            <%
                                if(conn != null) {
                                    try {
                                        Statement st2 = conn.createStatement();
                                        ResultSet rs2 = st2.executeQuery("SELECT Class_ID, Class_Name FROM Classes ORDER BY TO_NUMBER(REGEXP_SUBSTR(Class_Name, '[0-9]+')) ASC, Class_Name ASC");
                                        while(rs2.next()) {
                            %>
                                <option value="<%= rs2.getString("Class_ID") %>"><%= rs2.getString("Class_Name") %></option>
                            <%
                                        }
                                        rs2.close();
                                        st2.close();
                                    } catch(Exception e) {
                                        out.println("<option value=''>Error loading classes</option>");
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="input-group">
                        <label>Select Subject</label>
                        <select name="subjectID" required>
                            <option value="">-- Choose a Subject --</option>
                            <%
                                if(conn != null) {
                                    try {
                                        Statement st3 = conn.createStatement();
                                        ResultSet rs3 = st3.executeQuery("SELECT Subject_ID, Subject_Name FROM Subjects ORDER BY Subject_Name ASC");
                                        while(rs3.next()) {
                            %>
                                <option value="<%= rs3.getString("Subject_ID") %>"><%= rs3.getString("Subject_Name") %></option>
                            <%
                                        }
                                        rs3.close();
                                        st3.close();
                                    } catch(Exception e) {
                                        out.println("<option value=''>Error loading subjects</option>");
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <button type="submit" class="assign-btn">
                        Assign Teacher <i class="fas fa-paper-plane"></i>
                    </button>
                </form>
            </div>
        </div>
    </div>

</body>
</html>
<%

    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>