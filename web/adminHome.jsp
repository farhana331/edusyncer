<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    
    String role = (String) session.getAttribute("userRole");
    if(role == null || !role.equalsIgnoreCase("Admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');
        
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Poppins", sans-serif;
            background-color: #0a0a0a;
            color: #ffffff;
            line-height: 1.5;
            overflow: hidden; 
            height: 100vh;
            width: 100vw;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .background-objects {
            position: fixed;
            top: 0; left: 0; width: 100%; height: 100%;
            pointer-events: none; z-index: -1;
        }

        .bg-circle-1 {
            position: absolute; width: 400px; height: 400px;
            background: radial-gradient(circle, rgba(0, 110, 255, 0.12), transparent);
            border-radius: 50%; top: -100px; right: -100px;
        }
        
        .bg-circle-2 {
            position: absolute; width: 300px; height: 300px;
            background: radial-gradient(circle, rgba(139, 92, 246, 0.08), transparent);
            border-radius: 50%; bottom: -50px; left: -50px;
        }

        .container {
            width: 100%;
            max-width: 1200px;
            height: 90vh; 
            padding: 0 2rem;
            display: flex;
            flex-direction: column;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            padding-bottom: 15px;
            margin-bottom: 20px; 
        }

        .admin-header h1 {
            background: linear-gradient(to right, #38bdf8, #818cf8, #c084fc);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-size: 1.8rem;
            font-weight: 600;
        }

        .logout-btn {
            background: rgba(239, 68, 68, 0.1);
            color: #f87171;
            padding: 8px 20px;
            border-radius: 30px;
            text-decoration: none;
            border: 1px solid rgba(239, 68, 68, 0.4);
            transition: all 0.3s ease;
            font-weight: 600;
            font-size: 0.85rem;
        }

        .logout-btn:hover {
            background: #ef4444;
            color: white;
            box-shadow: 0 0 20px rgba(239, 68, 68, 0.3);
        }

      
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1.2fr 1.8fr;
            gap: 25px;
            flex: 1;
            align-items: stretch;
            padding-bottom: 20px; 
        }

        .form-box {
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255,255,255,0.1);
            padding: 20px 25px;
            border-radius: 20px;
            backdrop-filter: blur(15px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .form-box h3 {
            color: #38bdf8;
            margin-bottom: 10px;
            font-size: 1.15rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        label {
            display: block;
            margin-bottom: 2px;
            color: #94a3b8;
            font-size: 0.75rem;
        }

        input, select, textarea {
            width: 100%;
            padding: 8px 12px;
            margin-bottom: 8px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            color: white;
            outline: none;
            transition: all 0.3s;
            font-family: inherit;
            font-size: 0.8rem;
        }

        textarea {
            resize: none;
            height: 45px; 
        }

        input:focus, select:focus, textarea:focus {
            border-color: #38bdf8;
            background: rgba(255, 255, 255, 0.08);
        }

        select option {
            background-color: #111827; 
            color: #ffffff;
            padding: 10px;
        }
        
        .create-btn {
            width: 100%;
            padding: 10px;
            background: linear-gradient(135deg, #0284c7, #38bdf8);
            border: none;
            border-radius: 10px;
            color: white;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            margin-top: 5px;
            font-size: 0.85rem;
        }

        .create-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(56, 189, 248, 0.3);
        }

      
        .action-cards {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .action-card {
            background: rgba(30, 41, 59, 0.4);
            border: 1px solid rgba(255,255,255,0.1);
            padding: 0 20px;
            border-radius: 20px;
            text-decoration: none;
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            gap: 10px;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            text-align: center;
            backdrop-filter: blur(10px);
        }

        .action-card i {
            font-size: 2rem;
            transition: transform 0.3s;
        }

        .action-card:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.05);
            box-shadow: 0 15px 30px rgba(0,0,0,0.3);
        }

        .action-card span {
            font-weight: 600;
            font-size: 0.9rem;
            letter-spacing: 0.5px;
        }

        .card-academic i { color: #10b981; }
        .card-classes:hover { border-color: #FF69B4; }
        .card-sub:hover { border-color: #8b5cf6; }
        .card-admit i { color: #0ea5e9; }
        .card-admit:hover {
            border-color: #f59e0b;
            box-shadow: 0 15px 30px rgba(245, 158, 11, 0.15);
        }

        .card-allocate i { color: #f43f5e; }
        .card-allocate:hover { border-color: #FF69B4; }
        .card-teacher i { color: #8b5cf6; }
        .card-teacher:hover { border-color: #8b5cf6; }

        .card-manage-students { border: 1px solid transparent; }
        .card-manage-students i { color: #f59e0b; }
        .card-manage-students:hover {
            border-color: #f59e0b;
            box-shadow: 0 15px 30px rgba(245, 158, 11, 0.15);
        }

        @media (max-width: 992px) {
            body { overflow: auto; height: auto; padding: 20px 0; }
            .container { height: auto; }
            .dashboard-grid { grid-template-columns: 1fr; padding-bottom: 0; }
            .action-cards { grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); }
        }
    </style>
</head>
<body>

    <div class="background-objects">
        <div class="bg-circle-1"></div>
        <div class="bg-circle-2"></div>
    </div>

    <div class="container">
        <header class="admin-header">
            <h1><i class="fas fa-user-shield"></i> Welcome, <%= session.getAttribute("loggedUser") %></h1>
            <a href="logout.jsp" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
        </header>

        <div class="dashboard-grid">
            <div class="form-box">
                <h3><i class="fas fa-user-plus"></i> Register New User</h3>
                <form action="addUserProcess.jsp" method="POST">
                    <label>Unique User ID</label>
                    <input type="text" name="newUserID" placeholder="e.g. User ID" required>
                    
                    <div style="display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 10px;">
                        <div>
                            <label>Full Name</label>
                            <input type="text" name="newUserName" placeholder="Enter full name" required>
                        </div>
                        <div>
                            <label>Gender</label>
                            <select name="newGender" required>
                                <option value="" disabled selected hidden>Select</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                    </div>
                    
                    <label>Phone Number</label>
                    <input type="text" name="newUserPhone" placeholder="e.g. 017XXXXXXXX" required>
                    
                    <label>Address</label>
                    <textarea name="newUserAddress" placeholder="e.g. Dhanmondi, Dhaka" required></textarea>
                    
                    <label>Temporary Password</label>
                    <input type="password" name="newPassword" placeholder="••••••••" required>
                    
                    <label>Assign Role</label>
                    <select name="newRole" required>
                        <option value="Teacher">Teacher</option>
                        <option value="Guardian">Guardian</option>
                    </select>
                    
                    <button type="submit" class="create-btn">Confirm & Create</button>
                </form>
            </div>

            <div class="action-cards">
                
                <a href="manageAcademics.jsp" class="action-card card-academic card-classes">
                    <i class="fas fa-university"></i>
                    <span>Manage Classes</span>
                </a>

                <a href="manageSubject.jsp" class="action-card card-academic card-sub">
                    <i class="fas fa-book"></i>
                    <span>Manage Subjects</span>
                </a>

                <a href="admitStudent.jsp" class="action-card card-admit">
                    <i class="fas fa-user-graduate"></i>
                    <span>Admit Student</span>
                </a>

                <a href="allocateTeacher.jsp" class="action-card card-allocate">
                    <i class="fas fa-id-badge"></i>
                    <span>Allocate Teacher</span>
                </a>

                <a href="manageTeachers.jsp" class="action-card card-teacher">
                    <i class="fas fa-user-tie"></i>
                    <span>Manage Teachers</span>
                </a>
                
                <a href="manageStudents.jsp" class="action-card card-manage-students">
                    <i class="fas fa-users-cog"></i>
                    <span>Manage Students</span>
                </a>

            </div>
        </div>
    </div>

</body>
</html>
