<%@ page import="java.sql.*" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";  // Using service name
    String dbUsername = "SYSTEM";                                  // Oracle DB username
    String dbPassword = "skoracle";                                // Oracle DB password

    String user = request.getParameter("email");                   // User input: email
    String pass = request.getParameter("password");                // User input: password

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Load Oracle JDBC Driver
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // Establish a connection
        conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
       
        // Construct the SQL query with user inputs (make sure to sanitize inputs)
        String query = "SELECT * FROM Users WHERE TRIM(LOWER(email)) = TRIM(LOWER(?)) AND TRIM(password) = TRIM(?)";

        // Create a prepared statement to prevent SQL injection
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, user);
        pstmt.setString(2, pass);

        // Execute the query
        rs = pstmt.executeQuery();

        // Check if user exists and display results
        if (rs.next()) {
            // User exists, store username in session
            session.setAttribute("username", rs.getString("username")); // Store username in session
            
            // Redirect to home page
            response.sendRedirect("../pages/home.jsp");
            return; // Exit the script after redirecting
        } else {
            out.println("Invalid email or password.<br>");
        }
    } catch (SQLException e) {
        out.println("SQL Exception: " + e.getMessage() + "<br>");
    } catch (Exception e) {
        out.println("An error occurred: " + e.getMessage() + "<br>");
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            out.println("Error closing resources: " + ex.getMessage() + "<br>");
        }
    }
%>
