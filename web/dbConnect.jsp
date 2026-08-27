<%@ page import="java.sql.*" %>
<%
    Connection conn = null;
    try {  
        java.util.Locale.setDefault(java.util.Locale.US); 
        Class.forName("oracle.jdbc.driver.OracleDriver");   
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "IDP-1", "hello");        
    } catch(Exception e) {
        out.println("<h3 style='color:red;'>Database Connection Failed: " + e.getMessage() + "</h3>");
    }
%>