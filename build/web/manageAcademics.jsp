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
    <title>Manage Academics - EduSyncer</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: "Poppins", sans-serif;
            background-color: #0a0a0a;
            color: #ffffff;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .bg-glow {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 500px;
            height: 500px;
            background: radial-gradient(circle, rgba(0, 110, 255, 0.15), transparent 70%);
            z-index: -1;
            pointer-events: none;
        }

        .container {
            width: 100%;
            max-width: 450px;
            padding: 2rem;
            z-index: 10;
        }
        .header-area {
            text-align: center;
            margin-bottom: 2rem;
        }

        .header-area h2 {
            font-size: 2rem;
            background: linear-gradient(to right, #006eff, #00d4ff, #fadcfa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 0.5rem;
        }

        .back-link {
            color: #ccc;
            text-decoration: none;
            font-size: 0.9rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-link:hover {
            color: #00d4ff;
            transform: translateX(-5px);
        }

        .form-box {
            background: rgba(20, 20, 20, 0.8);
            border: 1px solid #333;
            padding: 2.5rem;
            border-radius: 20px;
            backdrop-filter: blur(15px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.6);
            transition: border-color 0.4s ease;
        }

        .form-box:hover {
            border-color: #006eff;
        }

        .form-box h3 {
            color: #fff;
            margin-bottom: 1.5rem;
            font-size: 1.3rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .form-box h3 i {
            color: #00d4ff;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #64a6fc;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        input {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 1.5rem;
            background: rgba(30, 30, 30, 0.7);
            border: 1px solid #444;
            border-radius: 10px;
            color: white;
            font-size: 1rem;
            outline: none;
            transition: all 0.3s ease;
        }

        input:focus {
            border-color: #00d4ff;
            background: rgba(40, 40, 40, 0.9);
            box-shadow: 0 0 12px rgba(0, 212, 255, 0.2);
            transform: translateY(-2px);
        }

        button {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #006eff, #00d4ff);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        button:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 212, 255, 0.4);
            filter: brightness(1.1);
        }

        button:active {
            transform: translateY(-1px);
        }

        .decor {
            position: absolute;
            width: 8px;
            height: 8px;
            background: #00d4ff;
            border-radius: 50%;
            filter: blur(1px);
            opacity: 0.5;
            animation: float 6s infinite ease-in-out;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-20px); }
        }
    </style>
</head>
<body>

    <div class="bg-glow"></div>
    <div class="decor" style="top: 20%; left: 15%;"></div>
    <div class="decor" style="bottom: 25%; right: 10%; animation-delay: 2s;"></div>

    <div class="container">
        <div class="header-area">
            <h2>Academic Management</h2>
            <a href="adminHome.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Dashboard
            </a>
        </div>

        <div class="form-box">
            <h3><i class="fas fa-graduation-cap"></i> Add New Class</h3>
            <form action="addClassProcess.jsp" method="POST">
                
                <label>Class ID</label>
                <input type="text" name="classID" placeholder="e.g., CLS-06" required>
                
                <label>Class Name</label>
                <input type="text" name="className" placeholder="e.g., Class 6" required>
                
                <button type="submit">
                    <i class="fas fa-plus-circle" style="margin-right: 8px;"></i> Add Class
                </button>
                
            </form>
        </div>
    </div>

</body>
</html>
