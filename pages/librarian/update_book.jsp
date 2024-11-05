<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String bookId = request.getParameter("book_id");
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
    String dbUsername = "SYSTEM";
    String dbPassword = "skoracle";

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
    <title>Update Book</title>
</head>
<body>
    <h2>Update Book</h2>
    <form method="post" action="../../auth/librarian/update_book.jsp">
        <input type="hidden" name="book_id" value="<%= bookId %>">

        <label for="title">Title:</label><br>
        <input type="text" id="title" name="title" value="<%= title %>" required><br>

        <label for="author">Author:</label><br>
        <input type="text" id="author" name="author" value="<%= author %>"><br>

        <label for="publisher">Publisher:</label><br>
        <input type="text" id="publisher" name="publisher" value="<%= publisher %>"><br>

        <label for="edition">Edition:</label><br>
        <input type="text" id="edition" name="edition" value="<%= edition %>"><br>

        <label for="category_id">Category:</label><br>
        <input type="number" id="category_id" name="category_id" value="<%= categoryId %>" required><br>

        <label for="total_copies">Total Copies:</label><br>
        <input type="number" id="total_copies" name="total_copies" value="<%= totalCopies %>" required><br>

        <label for="available_copies">Available Copies:</label><br>
        <input type="number" id="available_copies" name="available_copies" value="<%= availableCopies %>" required><br>

        <input type="submit" value="Update Book">
    </form>
</body>
</html>
