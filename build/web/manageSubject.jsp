<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
    <title>Subject Management - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Poppins", sans-serif;
            background: radial-gradient(circle at center, #0d0d2b 0%, #050505 100%);
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            position: relative;
        }

        .particles {
            position: absolute;
            width: 100%;
            height: 100%;
            z-index: 1;
            pointer-events: none;
        }

        .p {
            position: absolute;
            background: rgba(0, 212, 255, 0.2);
            border-radius: 50%;
            animation: float 12s infinite linear;
        }

        @keyframes float {
            0% { transform: translateY(110vh); opacity: 0; }
            50% { opacity: 0.5; }
            100% { transform: translateY(-10vh); opacity: 0; }
        }

        .form-outer {
            position: relative;
            width: 420px;
            height: 500px;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden; 
            z-index: 10;
        }

        .form-outer::before {
            content: '';
            position: absolute;
            width: 180px;
            height: 140%;
            background: linear-gradient(#00d4ff, #006eff);
            animation: rotateBorder 4s linear infinite;
            z-index: 1;
        }

        .form-outer::after {
            content: '';
            position: absolute;
            width: 180px;
            height: 140%;
            background: linear-gradient(#ff00d4, #868eff);
            animation: rotateBorder 4s linear infinite;
            animation-delay: -2s;
            z-index: 1;
        }

        @keyframes rotateBorder {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .form-box {
            position: absolute;
            inset: 4px; 
            background: linear-gradient(145deg, #0f172a, #1e1b4b);
            border-radius: 16px;
            z-index: 5;
            padding: 40px;
            display: flex;
            flex-direction: column;
        }

        .form-box h2 {
            font-size: 1.7rem;
            margin-bottom: 30px;
            text-align: center;
            background: linear-gradient(to right, #00d4ff, #ffffff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 600;
        }

        .back-nav { margin-bottom: 20px; }
        .back-nav a {
            color: #888;
            text-decoration: none;
            font-size: 0.85rem;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .back-nav a:hover { color: #00d4ff; }

        .input-group { margin-bottom: 25px; }
        .input-group label {
            display: block;
            font-size: 0.75rem;
            color: #64a6fc;
            margin-bottom: 8px;
            text-transform: uppercase;
            font-weight: bold;
        }

        .input-group input {
            width: 100%;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 12px;
            color: #fff;
            outline: none;
            transition: 0.3s;
        }

        .input-group input:focus {
            border-color: #00d4ff;
            background: rgba(255, 255, 255, 0.1);
        }

        .submit-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(90deg, #006eff, #00d4ff);
            border: none;
            color: #fff;
            font-weight: bold;
            border-radius: 10px;
            cursor: pointer;
            transition: 0.4s;
            text-transform: uppercase;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .submit-btn:hover {
            box-shadow: 0 0 20px rgba(0, 212, 255, 0.5);
            transform: translateY(-2px);
        }

    </style>
</head>
<body>

    <div class="particles">
        <div class="p" style="width: 6px; height: 6px; left: 10%; animation-delay: 0s;"></div>
        <div class="p" style="width: 4px; height: 4px; left: 40%; animation-delay: 2s;"></div>
        <div class="p" style="width: 8px; height: 8px; left: 70%; animation-delay: 4s;"></div>
        <div class="p" style="width: 5px; height: 5px; left: 85%; animation-delay: 6s;"></div>
    </div>

    <div class="form-outer">
        <div class="form-box">
            <div class="back-nav">
                <a href="adminHome.jsp"><i class="fas fa-chevron-left"></i> Dashboard</a>
            </div>
            
            <h2>Add Subject</h2>
            
            <form action="addSubjectProcess.jsp" method="POST">
                <div class="input-group">
                    <label>Subject ID</label>
                    <input type="text" name="subjectID" placeholder="e.g. SUB-101" required>
                </div>
                
                <div class="input-group">
                    <label>Subject Name</label>
                    <input type="text" name="subjectName" placeholder="e.g. Computer Graphics" required>
                </div>
                
                <button type="submit" class="submit-btn">
                    <span>Save Subject</span>
                    <i class="fas fa-plus-circle"></i>
                </button>
            </form>
        </div>
    </div>

</body>
</html>
