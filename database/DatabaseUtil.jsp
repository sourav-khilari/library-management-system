<%@ page import="java.sql.*" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.InputStream" %>
<%
    Connection getConnection() {
        String jdbcUrl = "";
        String dbUsername = "";
        String dbPassword = "";

        try (InputStream input = application.getResourceAsStream("../WEB-INF/db.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                out.println("Sorry, unable to find db.properties");
                return null;
            }
            // Load a properties file from class path
            prop.load(input);
            jdbcUrl = prop.getProperty("jdbcUrl");
            dbUsername = prop.getProperty("dbUsername");
            dbPassword = prop.getProperty("dbPassword");
        } catch (IOException ex) {
            out.println("Error loading properties: " + ex.getMessage() + "<br>");
        }

        Connection conn = null;
        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
            // Establish a connection
            conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
        } catch (SQLException | ClassNotFoundException e) {
            out.println("Connection error: " + e.getMessage() + "<br>");
        }
        return conn;
    }
%>
