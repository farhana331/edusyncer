<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    try {  
        java.util.Locale.setDefault(java.util.Locale.US); 
        Class.forName("oracle.jdbc.driver.OracleDriver");   
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "nabia", "nabia");        
    } catch(Exception e) {
        out.println("<h3 style='color:red;'>Database Connection Failed: " + e.getMessage() + "</h3>");
    }
%>