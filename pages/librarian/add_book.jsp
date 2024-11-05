<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.util.List" %>         
<%@ page import="java.util.ArrayList" %>    
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Check if user is a librarian
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("librarian")) {
        out.println("Access denied. Only librarians can add books.");
        return; // Stop processing if not a librarian
    }

    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/xe"; // Using service name
    String dbUsername = "system";                                  // Oracle DB username
    String dbPassword = "root";                                   // Oracle DB password

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
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f4f8;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"], input[type="number"], select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }
        input[type="submit"] {
            background-color: #28a745; /* Green color */
            color: white;
            border: none;
            padding: 10px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
            transition: background-color 0.3s;
            width: 100%;
        }
        input[type="submit"]:hover {
            background-color: #218838; /* Darker green on hover */
        }
        .error-message {
            color: red;
            text-align: center;
            margin-top: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Add a New Book</h1>
        <form method="post" action="../../auth/librarian/add_book.jsp">
            <label for="title">Title:</label>
            <input type="text" id="title" name="title" required>
            
            <label for="author">Author:</label>
            <input type="text" id="author" name="author" required>

            <label for="publisher">Publisher:</label>
            <input type="text" id="publisher" name="publisher" required>

            <label for="edition">Edition:</label>
            <input type="text" id="edition" name="edition">

            <label for="category">Category:</label>
            <select id="category" name="category_id" required>
                <option value="">Select a category</option>
                <% for (int i = 0; i < categories.size(); i++) { %>
                    <option value="<%= categoryIds.get(i) %>"><%= categories.get(i) %></option>
                <% } %>
            </select>

            <label for="total_copies">Total Copies:</label>
            <input type="number" id="total_copies" name="total_copies" required min="1">

            <input type="submit" value="Add Book">
            
            <%
                // Check for error message in the query string
                String errorMessage = request.getParameter("error");
                if (errorMessage != null) {
            %>
                <div class="error-message">
                    <strong>Error:</strong> <%= errorMessage %>
                </div>
            <%
                }
            %>
        </form>
    </div>
</body>
</html>
