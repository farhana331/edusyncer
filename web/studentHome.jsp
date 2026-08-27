<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
   
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equals("Student")) {
        response.sendRedirect("index.jsp");
        return;
    }
    String studentID = (String) session.getAttribute("loggedUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Poppins", sans-serif;
            background: radial-gradient(circle at center, #0f172a 0%, #020617 100%);
            color: #ffffff;
            min-height: 100vh;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(255, 255, 255, 0.02);
            backdrop-filter: blur(12px);
            padding: 15px 40px;
            border-bottom: 2px solid #facc15;
            box-shadow: 0 4px 20px rgba(250, 204, 21, 0.1);
        }

        .header h2 {
            font-size: 1.4rem;
            background: linear-gradient(to right, #38bdf8, #a855f7);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
        }

        .logout-btn {
            color: #facc15; 
            text-decoration: none;
            font-weight: bold;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: 0.3s;
        }
        .logout-btn:hover { color: #fff; transform: scale(1.05); }

        .container {
            max-width: 1100px;
            margin: 50px auto;
            padding: 0 20px;
        }

        .content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 30px;
        }

        .card {
            background: rgba(30, 41, 59, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.05);
            padding: 30px;
            border-radius: 24px;
            transition: all 0.4s ease;
            position: relative;
            overflow: hidden;
        }
        .card::before {
            content: '';
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 4px;
            background: linear-gradient(to right, #3b82f6, #8b5cf6);
        }

        .card:hover {
            transform: translateY(-8px);
            border-color: #facc15; 
            box-shadow: 0 10px 30px rgba(250, 204, 21, 0.15);
        }

        .card h3 {
            font-size: 1.25rem;
            margin-bottom: 15px;
            color: #facc15;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .profile-info {
            background: rgba(15, 23, 42, 0.6);
            padding: 20px;
            border-radius: 15px;
            border-left: 4px solid #3b82f6; 
        }

        .profile-info p { margin-bottom: 8px; color: #e2e8f0; }
        .profile-info strong { color: #a855f7; } 
        .action-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            padding: 12px 24px;
            background: linear-gradient(135deg, #2563eb, #7c3aed);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            margin-top: 20px;
            transition: 0.3s;
            box-shadow: 0 4px 15px rgba(124, 58, 237, 0.3);
        }

        .action-btn:hover {
            background: #facc15;
            color: #000;
            box-shadow: 0 8px 25px rgba(250, 204, 21, 0.4);
            transform: scale(1.02);
        }

        .icon-box {
            width: 45px;
            height: 45px;
            background: rgba(250, 204, 21, 0.1);
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #facc15;
            font-size: 1.2rem;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>

    <div class="header">
        <h2><i class="fas fa-rocket"></i> Student Portal: <%= studentID %></h2>
        <a href="logout.jsp" class="logout-btn">
            Logout <i class="fas fa-power-off"></i>
        </a>
    </div>

    <div class="container">
        <div class="content">
            
            <div class="card">
                <div class="icon-box"><i class="fas fa-user-circle"></i></div>
                <h3>My Profile</h3>
                <div class="profile-info">
                 <%
    if(conn != null) {
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            String sql = "SELECT Student_Name, Class_ID FROM Students WHERE Student_ID = ?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, studentID);
            rs = pst.executeQuery();
            if(rs.next()) {
%>
                <p><strong>Name:</strong> <%= rs.getString("Student_Name") %></p>
                <p><strong>Class:</strong> <%= rs.getString("Class_ID") %></p>
<%
            }
        } catch(Exception e) { 
            out.println("Error loading profile."); 
        } finally {
            if(rs != null) { try { rs.close(); } catch(Exception e) {} }
            if(pst != null) { try { pst.close(); } catch(Exception e) {} }
        }
    }
%>
                </div>
            </div>

            <div class="card">
                <div class="icon-box"><i class="fas fa-graduation-cap"></i></div>
                <h3>Academics</h3>
                <p style="color: #94a3b8;">Check your semester grades, overall CGPA, and specific subject remarks from teachers.</p>
                <a href="viewResults.jsp?studentID=<%= studentID %>" class="action-btn">
                    View Results <i class="fas fa-arrow-right"></i>
                </a>
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