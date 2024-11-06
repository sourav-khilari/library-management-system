<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update User Details</title>
</head>
<body>
    <%
        // Retrieve the form data
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String username = request.getParameter("username");

        // Check if password was provided, otherwise keep it as is
        if (password == null || password.isEmpty()) {
            // Don't update the password
            password = null;
        }

        Connection conn = null;
        PreparedStatement stmt = null;

        // Database connection using DriverManager
        try {
            // Set up database connection
            String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
            String dbUsername = "SYSTEM";
            String dbPassword = "skoracle";
            conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

            // Prepare the SQL query for updating user details
            String updateQuery = "UPDATE USERS SET email = ?";

            // Add password update if it's provided
            if (password != null) {
                updateQuery += ", password = ?";
            }
            

            updateQuery += " WHERE username = ?";

            stmt = conn.prepareStatement(updateQuery);

            // Set the parameters for the query
            stmt.setString(1, email);
            if (password != null) {
                stmt.setString(2, password);
                stmt.setString(3, username);
            } else {
                stmt.setString(2, username);
            }

            // Execute the update query
            int rowsUpdated = stmt.executeUpdate();

            // Check if the update was successful
            if (rowsUpdated > 0) {
                out.println("<h3>User details updated successfully!</h3>");
            } else {
                out.println("<h3>Failed to update user details.</h3>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h3>Error occurred while updating user details: " + e.getMessage() + "</h3>");
        } finally {
            // Close the resources
            try {
                if (stmt != null) {
                    stmt.close();
                }
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
</body>
</html>
