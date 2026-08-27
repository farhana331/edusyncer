<%@page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EduSyncer - Connecting Teachers & Parents</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<style>
  * {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: "Arial", sans-serif;
  background-color: #0a0a0a;
  color: #ffffff;
  line-height: 1.6;
}


.background-objects {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
  z-index: 1;
  overflow: hidden;
}

.bg-object {
  position: absolute;
  filter: blur(5px);
  opacity: 0.8;
  transition-timing-function: ease-in-out;
}

.bg-circle-1 {
  width: 200px;
  height: 200px;
  background: radial-gradient(circle, #868eff99, transparent);
  border-radius: 50%;
  top: 20%;
  left: 5%;
  animation: floatOrb1 35s infinite linear;
}

.bg-circle-2 {
  width: 200px;
  height: 200px;
  background: radial-gradient(circle, #bb79fa, transparent);
  border-radius: 50%;
  top: 60%;
  right: 8%;
  animation: floatOrb2 35s infinite linear;
}

.navbar {
  position: fixed;
  top: 0;
  width: 100%;
  background: rgba(10, 10, 10, 0.95);
  backdrop-filter: blur(10px);
  z-index: 1000;
  padding: 1rem 0;
  border-bottom: 1px solid #333;
}

.nav-container {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 0 2rem;
}

.nav-logo h2 {
  background: linear-gradient(to right, #006eff, #bce3fd, #fadcfa);

  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  font-size: 1.8rem;
  text-shadow: 0 0 20px rgba(0, 212, 255, 0.5);
}

.login-dropdown {
  position: relative;
}

.login-btn {
  background: linear-gradient(to right, #0069f3, #00b1c9);
  border: none;
  padding: 0.8rem 1.5rem;
  border-radius: 25px;
  font-weight: bold;
  color: white;
  cursor: pointer;
  transition:all 0.3s ease-in-out;
  box-shadow: 0 0 20px rgba(0, 212, 255, 0.3);
}

.login-btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 25px rgba(0, 212, 255, 0.5);
}

.dropdown-content {
  position: absolute;
  top: 100%;
  right: 0;
  background: rgba(20, 20, 20, 0.95);
  backdrop-filter: blur(10px);
  border: 1px solid #333;
  border-radius: 10px;
  min-width: 200px;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-10px);
  transition: all 0.3s ease;
  margin-top: 10px;
}

.dropdown-content.show {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

.dropdown-content a {
  display: flex;
  align-items: center;
  padding: 1rem;
  color: white;
  text-decoration: none;
  transition: all 0.3s ease;
  border-radius: 8px;
  margin: 5px;
}

.dropdown-content a:hover {
  background: linear-gradient(to right, #006eff, #ffe7e7);
  color: black;
  transform: translateX(5px);
}

.dropdown-content .icon i {
  margin-right: 10px;
  font-size: 1.2rem;
}

.hero {
  min-height: 100vh;
  display: flex;
  align-items: center;
  background: linear-gradient(
    to right bottom,
    #0a0a0a 0%,
    #0b0b20 50%,
    #16213e 100%
  );
  position: relative;
  overflow: hidden;
  padding-top: 80px;
}

.hero-container {
  max-width: 1200px;
  margin: 0 auto;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
  padding: 0 2rem;
}

.hero-title {
  font-size: 3rem;
  font-weight: bold;
  background: linear-gradient(to right, #006eff, #0099ff, #fadcfa);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  margin-bottom: 1rem;
  text-shadow: 0 0 50px rgba(0, 212, 255, 0.5);
  position: relative;
  z-index: 2;
}

.hero-subtitle {
  font-size: 1.2rem;
  color: #cccccc;
  margin-bottom: 2rem;
  position: relative;
  z-index: 2;
}

.communication-visual {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 2rem;
  font-size: 4rem;
  position: relative;
}

.connection-line {
  width: 100px;
  height: 4px;
  background: linear-gradient(to right, #006eff, #fadcfa);
  border-radius: 2px;
  position: relative;
  animation: pulse 2s infinite;
}

.floating-particles {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
  pointer-events: none;
}

.particle {
  position: absolute;
  width: 5px;
  height: 5px;
  background: #00d5ffb7;
  border-radius: 50%;
  animation: float 6s infinite linear;
}

.particle:nth-child(1) {
  top: 20%;
  left: 20%;
  animation-delay: 0s;
}

.particle:nth-child(2) {
  top: 60%;
  left: 80%;
  animation-delay: 2s;
}

.particle:nth-child(3) {
  top: 80%;
  left: 40%;
  animation-delay: 4s;
}

.features {
  padding: 5rem 0;
  background: #111111;
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 2rem;
}

.section-title {
  text-align: center;
  font-size: 2.5rem;
  margin-bottom: 3rem;
  background: linear-gradient(to right, #006eff, #fffbff);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
}

.feature-card {
  border: 1px solid #333;
  border-radius: 15px;
  padding: 2rem;
  text-align: center;
  transition: all 0.3s ease;
  position: relative;
  z-index: 2;
  backdrop-filter: blur(30px);
  display: flex;
  flex-direction: column;
  align-items: center;
}

.feature-card:hover {
  transform: translateY(-10px);
  border-color: #00d4ff;
  box-shadow: 0 10px 30px rgba(0, 212, 255, 0.3);
}

.feature-icon i,
.teacher-icon i,
.parent-icon i {
  color: #3e92ff;
  transition: all 0.3s ease;
  font-size: 36px;
  margin-bottom: 10px;
}

.feature-card:hover .feature-icon i {
  color: #fffbff;
  transform: scale(1.1);
}

.teacher-icon i,
.parent-icon i {
  filter: drop-shadow(0 0 10px rgba(0, 212, 255, 0.5));
}

.icon i {
  vertical-align: middle;
}

.feature-card h3 {
  font-size: 1.5rem;
  width: fit-content;
  margin-bottom: 1rem;
  background: linear-gradient(to right, #006eff, #fffbff);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.dashboard-preview {
  padding: 5rem 0;
}

.parent-section {
  background: #111111;
}

.dashboard-mockup {
  border: 1px solid #333;
  border-radius: 15px;
  overflow: hidden;
  max-width: 600px;
  position: relative;
  z-index: 2;
  margin: 0 auto;
}

.mockup-header {
  position: relative;
  z-index: 2;
  padding: 1rem;
  display: flex;
  align-items: center;
  gap: 1rem;
  border-bottom: 1px solid #333;
}

.mockup-dots {
  display: flex;
  gap: 5px;
}

.mockup-dots span {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background: #ff5f56;
}

.mockup-dots span:nth-child(2) {
  background: #ffbd2e;
}

.mockup-dots span:nth-child(3) {
  background: #27ca3f;
}

.mockup-title {
  color: #cccccc;
  font-weight: bold;
}

.mockup-content {
  padding: 2rem;
}

.dashboard-item {
  margin-bottom: 2rem;
}

.dashboard-item h4 {
  color: #64a6fc;
  margin-bottom: 1rem;
}

.progress-bar {
  background: #333;
  height: 10px;
  border-radius: 5px;
  overflow: hidden;
  margin-bottom: 0.5rem;
}

.progress {
  background: linear-gradient(to right, #006eff, #fffbff);

  height: 100%;
  border-radius: 5px;
  transition: width 0.3s ease;
}

.grade-list {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.grade-item {
  background: #333;
  padding: 0.5rem 1rem;
  border-radius: 5px;
  border-left: 3px solid #64a6fc;
}

.circular-progress {
  display: flex;
  justify-content: center;
  margin: 1rem 0;
}

.circle {
  width: 100px;
  height: 100px;
  border: 8px solid #333;
  border-top: 8px solid #00d4ff;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.5rem;
  font-weight: bold;
  color: #00d4ff;
}

.attendance-chart {
  display: flex;
  gap: 10px;
  align-items: end;
  height: 100px;
}

.chart-bar {
  background: linear-gradient(to top, #006eff, #fffbff);
  width: 30px;
  border-radius: 3px 3px 0 0;
  transition: height 0.3s ease;
}

.cta {
  padding: 5rem 0;
  background: linear-gradient(135deg, #1a1a2e, #16213e);
  text-align: center;
}

.cta-title {
  font-size: 3rem;
  margin-bottom: 2rem;
  background: linear-gradient(to right, #4d9aff 20%, #5cbdfd 60%, #f7edf7 70%);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.cta-button {
  background: linear-gradient(to right, #006eff, #38c3fa);
  border: none;
  padding: 1rem 3rem;
  font-size: 1.2rem;
  border-radius: 30px;
  color: white;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 0 30px rgba(0, 212, 255, 0.5);
}

.cta-button:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 40px rgba(0, 212, 255, 0.7);
}

.footer {
  background: #0a0a0a;
  padding: 3rem 0 1rem;
  border-top: 1px solid #333;
}

.footer-content {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
}

.footer-section h3 {
  color: #00d4ff;
  margin-bottom: 1rem;
}

.footer-section a {
  color: #cccccc;
  text-decoration: none;
  display: block;
  margin-bottom: 0.5rem;
  transition: color 0.3s ease;
}

.footer-section a:hover {
  color: #00d4ff;
}

.social-icons {
  display: flex;
  gap: 1rem;
}

.social-icon {
  font-size: 1.2rem;
  border-radius: 50%;
  background: rgba(0, 212, 255, 0.1);
  transition: all 0.3s ease;
  width: 50px;
  height: 50px;
  display: flex !important;
  justify-content: center;
  align-items: center;
}

.social-icon i {
  transition: all 0.3s ease;
}

.social-icon:hover i {
  transform: scale(1.1);
}

.social-icon:hover {
  background: rgba(0, 212, 255, 0.3);
  transform: translateY(-3px);
}



.login-container {
  min-height: 100vh;
  display: none;
  align-items: center;
  justify-content: center;
  position: relative;
  padding: 2rem;
}

.login-container-show{
  display: flex;
  background: none;
min-height: 100vh;
}

.login-box {
  background: rgba(20, 20, 20, 0.9);
  border: 1px solid #333;
  border-radius: 20px;
  padding: 3rem;
  width: 100%;
  max-width: 400px;
  backdrop-filter: blur(10px);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
}

.login-header {
  text-align: center;
  margin-bottom: 2rem;
}

.login-header h1 {
  background: linear-gradient(to right, #006eff, #97d0f7, #faebfa);
  background-clip: text;
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  font-size: 2.2rem;
  margin-bottom: 0.5rem;
}

.login-header h2 {
  color: #cccccc;
  font-size: 1.5rem;
}

.form-group {
  margin-bottom: 1.5rem;
}

.form-group label {
  display: block;
  margin-bottom: 0.5rem;
  color: #64a6fc;

  font-weight: bold;
}

.form-group input {
  width: 100%;
  padding: 1rem;
  background: rgba(30, 30, 30, 0.8);
  border: 1px solid #333;
  border-radius: 10px;
  color: white;
  font-size: 1rem;
  transition: all 0.3s ease;
}

.form-group input:focus {
  outline: none;
  border-color: #00d4ff;
  transform: scale(1.02);
  box-shadow: 0 0 10px rgba(0, 212, 255, 0.3);
}

.login-submit {
  width: 100%;
  background: linear-gradient(to right, #006eff, #0099ff, #fadcfa);

  border: none;
  padding: 1rem;
  border-radius: 10px;
  color: white;
  font-size: 1.1rem;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-bottom: 2rem;
}

.login-submit:hover {
  transform: translateY(-2px);
  box-shadow: 0 5px 20px rgba(0, 212, 255, 0.5);
}

.login-info {
  background: rgba(0, 212, 255, 0.1);
  border: 1px solid rgba(0, 212, 255, 0.3);
  border-radius: 10px;
  padding: 1rem;
  margin-bottom: 1rem;
}

.login-info h3 {
  color: #00d4ff;
  margin-bottom: 0.5rem;
  font-size: 1rem;
}

.demo-creds p {
  margin-bottom: 0.3rem;
  font-size: 0.9rem;
}

.back-home {
  text-align: center;
}

.back-home a {
  color: #cccccc;
  text-decoration: none;
  transition: color 0.3s ease;
}

.back-home a:hover {
  color: #00d4ff;
}

.login-particles {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  pointer-events: none;
}

.login-particles .particle {
  position: absolute;
  width: 3px;
  height: 3px;
  background: #00d4ff;
  border-radius: 50%;
  animation: float 8s infinite linear;
}

.login-particles .particle:nth-child(1) {
  top: 10%;
  left: 10%;
  animation-delay: 0s;
}

.login-particles .particle:nth-child(2) {
  top: 20%;
  left: 80%;
  animation-delay: 2s;
}

.login-particles .particle:nth-child(3) {
  top: 70%;
  left: 20%;
  animation-delay: 4s;
}

.login-particles .particle:nth-child(4) {
  top: 80%;
  left: 70%;
  animation-delay: 6s;
}


.hidden{
  display: none;
}
/* Animations */
@keyframes pulse {
  0%,
  100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

@keyframes float {
  0% {
    transform: translateX(0px) translateY(0px) rotate(0deg);
    opacity: 0.8;
  }
  50% {
    transform: translateX(-30px) translateY(-70px) rotate(180deg);
    opacity: 0;
  }
  100% {
    transform: translateX(0px) translateY(0px) rotate(360deg);
    opacity: 0.8;
  }
}

@keyframes floatOrb1 {
  0% {
    transform: translateX(0px) rotate(0deg);
    opacity: 0.8;
  }
  50% {
    transform: translateX(150px) rotate(180deg);
    opacity: 0.5;
  }
  100% {
    transform: translateX(0px) rotate(360deg);
    opacity: 0.8;
  }
}

@keyframes floatOrb2 {
  0% {
    transform: translateY(0px) rotate(0deg);
    opacity: 0.8;
  }
  50% {
    transform: translateY(-140px) rotate(180deg);
    opacity: 0.5;
  }
  100% {
    transform: translateY(0px) rotate(360deg);
    opacity: 0.8;
  }
}

@media (max-width: 768px) {
  .hero-container {
    grid-template-columns: 1fr;
    text-align: center;
  }

  .hero-title {
    font-size: 2rem;
  }

  .features-grid {
    grid-template-columns: 1fr;
  }

  .nav-container {
    padding: 0 1rem;
  }

  .container {
    padding: 0 1rem;
  }

  .cta-title {
    font-size: 2rem;
  }

  .footer-content {
    grid-template-columns: 1fr;
    text-align: center;
  }

  .bg-circle-1,
  .bg-circle-2,
  .bg-circle-3 {
    width: 150px;
    height: 150px;
  }

  .bg-square-1 {
    width: 100px;
    height: 100px;
  }

  .bg-triangle-1 {
    border-left: 60px solid transparent;
    border-right: 60px solid transparent;
    border-bottom: 90px solid rgba(255, 0, 255, 0.6);
  }
}


</style>
<body id="home">
    <div class="background-objects">
        <div class="bg-object bg-circle-1"></div>
        <div class="bg-object bg-circle-2"></div>
    </div>

    <div class="floating-particles">
        <div class="particle"></div>
        <div class="particle"></div>
        <div class="particle"></div>
    </div>

    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo" onclick="window.location.href='index.jsp'">
                <h2>EduSyncer</h2>
            </div>
            <div class="nav-menu">
                
                    <button class="login-btn" id="loginBtn" onclick="window.location.href='login-portal.jsp'">Login</button>
                    
                
            </div>
        </div>
    </nav>

    <section class="hero">
        <div class="hero-container">
            <div class="hero-content">
                <h1 class="hero-title">Connecting Teachers & Parents in Real Time</h1>
                <p class="hero-subtitle">Streamline communication, track progress, and stay connected with your school community.</p>
            </div>
            <div class="hero-image">
                <div class="communication-visual">
                    <div class="teacher-icon"><i class="fas fa-chalkboard-teacher"></i></div>
                    <div class="connection-line"></div>
                    <div class="parent-icon"><i class="fas fa-users"></i></div>
                </div>
            </div>
        </div>
    </section>

    <section class="features">
        <div class="container">
            <h2 class="section-title">Platform Features</h2>
            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon"><i class="fas fa-chart-line"></i></div>
                    <h3>Progress Tracking</h3>
                    <p>Monitor student performance with real-time grades and analytics.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fas fa-calendar-check"></i></div>
                    <h3>Attendance Management</h3>
                    <p>Easily mark and view attendance records for the entire class.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fas fa-comments"></i></div>
                    <h3>Communication Hub</h3>
                    <p>Share notices and comments seamlessly between teachers and parents.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="dashboard-preview parent-section">
        <div class="container">
            <h2 class="section-title">Parent's Dashboard</h2>
            <div class="dashboard-mockup">
                <div class="mockup-header">
                    <div class="mockup-dots"><span></span><span></span><span></span></div>
                    <span class="mockup-title">Parent Dashboard</span>
                </div>
                <div class="mockup-content">
                    <div class="dashboard-item">
                        <h4><i class="fas fa-chart-line" style="margin-right: 8px"></i>Child's Progress</h4>
                        <div class="circular-progress">
                            <div class="circle"><span>92%</span></div>
                        </div>
                    </div>
                    <div class="dashboard-item">
                        <h4><i class="fas fa-calendar-alt" style="margin-right: 8px"></i>Attendance History</h4>
                        <div class="attendance-chart">
                            <div class="chart-bar" style="height: 80%"></div>
                            <div class="chart-bar" style="height: 95%"></div>
                            <div class="chart-bar" style="height: 75%"></div>
                            <div class="chart-bar" style="height: 90%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="cta">
        <div class="container">
            <h2 class="cta-title">Stay Connected. Stay Informed.</h2>
            <button class="cta-button" onclick="window.location.href='login-portal.jsp'">Join Now</button>  <!-- FIXED: Direct to teacher login -->
        </div>
    </section>

    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Contact Info</h3>
                    <p><i class="fas fa-envelope" style="margin-right: 8px"></i>edusyncer@gmail.com</p>
                    <p><i class="fas fa-phone" style="margin-right: 8px"></i>+1 (555) 123-4567</p>
                    
                </div>
                <div class="footer-section">
                    <h3>Quick Links</h3>
                    <a href="#features">Features</a>
                    <a href="#dashboard">Dashboard</a>
                    <a href="login-teacher.jsp">Login</a>
                </div>
                <div class="footer-section">
                    <h3>Follow Us</h3>
                    <div class="social-icons">
                        <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

    <script>
 

 
const featureCards = document.querySelectorAll(".feature-card");
featureCards.forEach((card) => {
    card.addEventListener("mouseenter", function () {
        this.style.transform = "translateY(-10px) scale(1.02)";
    });
    card.addEventListener("mouseleave", function () {
        this.style.transform = "translateY(0) scale(1)";
    });
});


const ctaButton = document.querySelector(".cta-button");
if (ctaButton) {
    ctaButton.addEventListener("click", function () {
        this.style.transform = "scale(0.95)";
        setTimeout(() => {
            this.style.transform = "scale(1)";
        }, 150);
    });
}
    </script>
    
</body>
</html>
