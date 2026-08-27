<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnect.jsp" %>
<%
    String sID = request.getParameter("subjectID");
    String sName = request.getParameter("subjectName");

    boolean isSuccess = false;
    String statusTitle = "";
    String statusMsg = "";
    String redirectUrl = "manageSubject.jsp";

    if(conn != null) {
        PreparedStatement pstCheck = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            String checkSql = "SELECT COUNT(*) FROM Subjects WHERE LOWER(TRIM(Subject_Name)) = LOWER(TRIM(?))";
            pstCheck = conn.prepareStatement(checkSql);
            pstCheck.setString(1, sName);
            rs = pstCheck.executeQuery();
            
            int count = 0;
            if(rs.next()) {
                count = rs.getInt(1);
            }
            
            if(count > 0) {
                isSuccess = false;
                statusTitle = "Already Exists!";
                statusMsg = "The subject <b>" + sName + "</b> already exists in the curriculum. Please use a unique subject name.";
            } else {
                String sql = "INSERT INTO Subjects (Subject_ID, Subject_Name) VALUES (?, ?)";
                pst = conn.prepareStatement(sql);
                pst.setString(1, sID);
                pst.setString(2, sName);
                int rows = pst.executeUpdate();
                
                if(rows > 0) {
                    isSuccess = true;
                    statusTitle = "Subject Added!";
                    statusMsg = "Subject <b>" + sName + "</b> (ID: " + sID + ") has been successfully added to the curriculum.";
                }
            }
        } catch(Exception e) {
            isSuccess = false;
            statusTitle = "Failed to Add!";
            String fullError = e.getMessage();
            
            if(fullError != null && fullError.contains("ORA-00001")) {
                statusMsg = "The Subject ID <b>" + sID + "</b> already exists. Please use a unique Subject ID.";
            } else if(fullError != null && fullError.contains("ORA-")) {
                statusMsg = "A database error occurred while registering the subject. Please check your inputs.";
            } else {
                statusMsg = "An unexpected error occurred: " + fullError.replace("'", "");
            }
        } finally {
            if(rs != null) try { rs.close(); } catch(Exception e) {}
            if(pstCheck != null) try { pstCheck.close(); } catch(Exception e) {}
            if(pst != null) try { pst.close(); } catch(Exception e) {}
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Processing Subject Data</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: #020617;
            color: #f1f5f9;
            font-family: 'Poppins', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            overflow: hidden;
        }

        .status-card {
            background: rgba(30, 41, 59, 0.4);
            backdrop-filter: blur(15px);
            padding: 40px;
            border-radius: 25px;
            text-align: center;
            max-width: 400px;
            width: 90%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.6);
            border: 1px solid <%= isSuccess ? "rgba(56, 189, 248, 0.3)" : "rgba(239, 68, 68, 0.3)" %>;
            animation: cardFade 0.6s ease-out;
        }

        @keyframes cardFade {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .icon-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            margin: 0 auto 20px;
            background: <%= isSuccess ? "rgba(56, 189, 248, 0.1)" : "rgba(239, 68, 68, 0.1)" %>;
            color: <%= isSuccess ? "#38bdf8" : "#f87171" %>;
            border: 2px solid <%= isSuccess ? "rgba(56, 189, 248, 0.2)" : "rgba(239, 68, 68, 0.2)" %>;
        }

        h2 { margin-bottom: 12px; font-weight: 600; color: #fff; }
        p { color: #94a3b8; font-size: 0.95rem; line-height: 1.6; margin-bottom: 25px; }

        .btn-manual {
            display: inline-block;
            padding: 12px 25px;
            background: <%= isSuccess ? "#38bdf8" : "#475569" %>;
            color: <%= isSuccess ? "#020617" : "#fff" %>;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            transition: 0.3s;
        }

        .loader-bar {
            height: 4px;
            background: rgba(255,255,255,0.05);
            margin-top: 30px;
            border-radius: 10px;
            overflow: hidden;
        }

        .loader-fill {
            height: 100%;
            background: <%= isSuccess ? "#38bdf8" : "#f87171" %>;
            width: 100%;
            animation: progress 3s linear forwards;
        }

        @keyframes progress { from { width: 100%; } to { width: 0%; } }

        .status-card:hover .loader-fill {
            animation-play-state: paused;
        }
    </style>
</head>
<body>

    <div class="status-card" id="statusCard">
        <div class="icon-circle">
            <i class="fas <%= isSuccess ? "fa-book-open" : "fa-exclamation-circle" %>"></i>
        </div>
        <h2><%= statusTitle %></h2>
        <p><%= statusMsg %></p>
        
        <a href="<%= redirectUrl %>" class="btn-manual">Return to Academics</a>

        <div class="loader-bar">
            <div class="loader-fill"></div>
        </div>
        <div style="margin-top: 15px; font-size: 0.8rem; color: #64748b;" id="redirectText">
            Redirecting in 3 seconds...
        </div>
    </div>

    <script>
        let timeLeft = 3;
        let card = document.getElementById("statusCard");
        let redirectText = document.getElementById("redirectText");
        
        let countdownInterval = setInterval(function() {
            timeLeft--;
            if (timeLeft > 0) {
                redirectText.innerText = "Redirecting in " + timeLeft + " seconds...";
            } else {
                redirectText.innerText = "Redirecting now...";
            }
        }, 1000);

        let redirectTimeout = setTimeout(function() {
            window.location.href = "<%= redirectUrl %>";
        }, 3000);

        card.addEventListener("mouseenter", function() {
            clearTimeout(redirectTimeout);
            clearInterval(countdownInterval);
            redirectText.innerText = "Paused (Move mouse away to resume)";
        });

        card.addEventListener("mouseleave", function() {
            redirectTimeout = setTimeout(function() {
                window.location.href = "<%= redirectUrl %>";
            }, 1500);
            redirectText.innerText = "Resuming redirection...";
        });
    </script>

</body>
</html>
<%
    if (conn != null && !conn.isClosed()) {
        conn.close();
    }
%>