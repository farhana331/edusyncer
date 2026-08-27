<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>School Portal - Login</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            background: linear-gradient(-45deg, #050505, #0d0d2b, #16213e, #050505);
            background-size: 400% 400%;
            animation: gradientBG 15s ease infinite;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            position: relative;
        }

        @keyframes gradientBG {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        .background-blobs {
            position: absolute;
            width: 100%;
            height: 100%;
            z-index: 1;
            pointer-events: none;
        }

        .blob {
            position: absolute;
            background: rgba(0, 212, 255, 0.1);
            border-radius: 50%;
            filter: blur(50px);
            animation: move 20s infinite alternate;
        }

        @keyframes move {
            from { transform: translate(0, 0); }
            to { transform: translate(100px, 100px); }
        }

        .login-box {
            background: rgba(255, 255, 255, 0.03);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 50px 40px;
            border-radius: 30px;
            width: 100%;
            max-width: 420px;
            text-align: center;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.5);
            z-index: 10;
        }

        .login-box h2 {
            font-size: 2rem;
            margin-bottom: 10px;
            background: linear-gradient(to right, #00d4ff, #ffffff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
        }

        .login-box p {
            color: #888;
            font-size: 0.9rem;
            margin-bottom: 30px;
        }

        .form-group {
            margin-bottom: 20px;
            position: relative;
            text-align: left;
        }

        .form-group i {
            position: absolute;
            left: 15px;
            top: 42px;
            color: #64a6fc;
            font-size: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #00d4ff;
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-left: 5px;
        }

        .form-group input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: white;
            font-size: 1rem;
            outline: none;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            border-color: #00d4ff;
            background: rgba(255, 255, 255, 0.1);
            box-shadow: 0 0 15px rgba(0, 212, 255, 0.2);
        }

        .login-submit {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #006eff, #00d4ff);
            border: none;
            border-radius: 12px;
            color: white;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            transition: 0.4s;
            margin-top: 15px;
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: 0 10px 20px rgba(0, 110, 255, 0.3);
        }

        .login-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(0, 212, 255, 0.5);
            letter-spacing: 2px;
        }

        .back-home {
            margin-top: 25px;
        }

        .back-home a {
            color: #888;
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .back-home a:hover {
            color: #fff;
        }

    </style>
</head>
<body>

    <div class="background-blobs">
        <div class="blob" style="width: 300px; height: 300px; top: 10%; left: 10%;"></div>
        <div class="blob" style="width: 200px; height: 200px; bottom: 20%; right: 15%; animation-delay: -5s;"></div>
    </div>

    <div class="login-box">
        <i class="fas fa-shield-halved" style="font-size: 3rem; color: #00d4ff; margin-bottom: 20px;"></i>
        <h2>Welcome Back</h2>
        <p>Please enter your credentials to access the portal</p>
        
        <form action="loginProcess.jsp" method="POST">
            <div class="form-group">
                <label>User ID</label>
                <i class="fas fa-user"></i>
                <input type="text" name="userID" placeholder="Enter your ID" required>
            </div>
            
            <div class="form-group">
                <label>Password</label>
                <i class="fas fa-lock"></i>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>
            
            <button type="submit" class="login-submit">
                Login Now <i class="fas fa-arrow-right-to-bracket" style="margin-left: 10px;"></i>
            </button>
        </form>
        
        <div class="back-home">
            <a href="index.jsp"><i class="fas fa-house"></i> Back to Home</a>
        </div>
    </div>

</body>
</html>
