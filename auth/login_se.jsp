<%@ page import="java.sql.*" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";  // Using service name
    String dbUsername = "system";                                  // Oracle DB username
    String dbPassword = "root";                                // Oracle DB password

    String user = request.getParameter("email");                   // User input: email
    String pass = request.getParameter("password");                // User input: password

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        // Load Oracle JDBC Driver
        Class.forName("oracle.jdbc.driver.OracleDriver");

        // Establish a connection
        conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
       
        
        // Debug: Print the inputs
        //out.println("Debug - Entered Email: " + user + "<br>");
        //out.println("Debug - Entered Password: " + pass + "<br>");

        // Construct the SQL query with user inputs (make sure to sanitize inputs)
        String query = "select * from Users WHERE TRIM(LOWER(email)) = TRIM(LOWER('"+ user +"')) AND TRIM(password) = TRIM('"+ pass +"')";
        
        // Debug: Print the constructed query
        //out.println("Executing query: " + query + "<br>");
        
        // Create a statement
        stmt = conn.createStatement();
        
        // Execute the query
        rs = stmt.executeQuery(query);

        // Check if user exists and display results
        if (rs.next()) {
            response.sendRedirect("../pages/home.jsp?username=" + rs.getString("username"));
            return; // Exit the script after redirecting
            //out.println("Username: " + rs.getString("username") + "<br>");
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
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            out.println("Error closing resources: " + ex.getMessage() + "<br>");
        }
    }
%>
