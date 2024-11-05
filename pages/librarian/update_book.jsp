<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String bookId = request.getParameter("book_id");
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/xe";
    String dbUsername = "system";
    String dbPassword = "root";

    // Initialize variables for book details
    String title = "", author = "", publisher = "", edition = "";
    int categoryId = 0, totalCopies = 0, availableCopies = 0;

    // Retrieve current book details
    try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
         PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM Books WHERE book_id = ?")) {

        pstmt.setInt(1, Integer.parseInt(bookId));
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            author = rs.getString("author");
            publisher = rs.getString("publisher");
            edition = rs.getString("edition");
            categoryId = rs.getInt("category_id");
            totalCopies = rs.getInt("total_copies");
            availableCopies = rs.getInt("available_copies");
        }
    } catch (SQLException e) {
        out.println("Error retrieving book details: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Book</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        h2 {
            color: #333;
        }
        form {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"],
        input[type="number"],
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background-color: #5cb85c;
            color: white;
            border: none;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #4cae4c;
        }
    </style>
</head>
<body>
    <h2>Update Book</h2>
    <form method="post" action="../../auth/librarian/update_book.jsp">
        <input type="hidden" name="book_id" value="<%= bookId %>">

        <label for="title">Title:</label>
        <input type="text" id="title" name="title" value="<%= title %>" required>

        <label for="author">Author:</label>
        <input type="text" id="author" name="author" value="<%= author %>">

        <label for="publisher">Publisher:</label>
        <input type="text" id="publisher" name="publisher" value="<%= publisher %>">

        <label for="edition">Edition:</label>
        <input type="text" id="edition" name="edition" value="<%= edition %>">

        <label for="category_id">Category:</label>
        <input type="number" id="category_id" name="category_id" value="<%= categoryId %>" required>

        <label for="total_copies">Total Copies:</label>
        <input type="number" id="total_copies" name="total_copies" value="<%= totalCopies %>" required>

        <label for="available_copies">Available Copies:</label>
        <input type="number" id="available_copies" name="available_copies" value="<%= availableCopies %>" required>

        <input type="submit" value="Update Book">
    </form>

    <% if (request.getParameter("success") != null) { %>
        <script type="text/javascript">
            alert('Book updated successfully!');
            window.location.href = '../../pages/librarian/librarian_home.jsp';
        </script>
    <% } %>
</body>
</html>
