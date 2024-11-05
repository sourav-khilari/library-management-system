<%@ page import="java.sql.*" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";  // Using service name
    String username = "SYSTEM";                       // Oracle DB username
    String password = "skoracle";                     // Oracle DB password
    //String username = System.getenv("DB_USERNAME");
    //String password = System.getenv("DB_PASSWORD");


    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        // Load Oracle JDBC Driver
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // Establish a connection
        conn = DriverManager.getConnection(jdbcUrl, username, password);

        // Test connection by executing a simple query
        String query = "SELECT * FROM EMP7";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(query);

        // Display results
        while (rs.next()) {
            out.println("Column1: " + rs.getString("EMPNO")+"<br>");
            out.println("Column2: " + rs.getString("ename")+"<br>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
%>
