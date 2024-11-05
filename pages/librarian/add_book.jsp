<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.List" %>         <!-- Import List -->
<%@ page import="java.util.ArrayList" %>    <!-- Import ArrayList -->
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Check if user is a librarian
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("librarian")) {
        out.println("Access denied. Only librarians can add books.");
        return; // Stop processing if not a librarian
    }

    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"; // Using service name
    String dbUsername = "SYSTEM";                                  // Oracle DB username
    String dbPassword = "skoracle";                                // Oracle DB password

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    // Get categories from the database
    List<String> categories = new ArrayList<>();
    List<Integer> categoryIds = new ArrayList<>();
    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
        
        // Query to retrieve categories
        stmt = conn.createStatement();
        String sql = "SELECT category_id, category_name FROM Category";
        rs = stmt.executeQuery(sql);
        
        while (rs.next()) {
            categoryIds.add(rs.getInt("category_id"));
            categories.add(rs.getString("category_name"));
        }
    } catch (SQLException | ClassNotFoundException e) {
        out.println("Error retrieving categories: " + e.getMessage());
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException ex) {
            out.println("Error closing resources: " + ex.getMessage());
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Book</title>
</head>
<body>
    <h1>Add a New Book</h1>
    <form method="post" action="../../auth/librarian/add_book.jsp">
        <label for="title">Title:</label><br>
        <input type="text" id="title" name="title" required><br>
        
        <label for="author">Author:</label><br>
        <input type="text" id="author" name="author"><br>

        <label for="publisher">Publisher:</label><br>
        <input type="text" id="publisher" name="publisher"><br>

        <label for="edition">Edition:</label><br>
        <input type="text" id="edition" name="edition"><br>

        <label for="category">Category:</label><br>
        <select id="category" name="category_id" required>
            <option value="">Select a category</option>
            <% for (int i = 0; i < categories.size(); i++) { %>
                <option value="<%= categoryIds.get(i) %>"><%= categories.get(i) %></option>
            <% } %>
        </select><br><br>

        <label for="total_copies">Total Copies:</label><br>
        <input type="number" id="total_copies" name="total_copies" required><br>

        <input type="submit" value="Add Book">
    </form>
</body>
</html>
