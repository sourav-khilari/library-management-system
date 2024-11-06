<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/xe";
String dbUsername = "system";
String dbPassword = "root";;

    String bookId = request.getParameter("book_id");
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String publisher = request.getParameter("publisher");
    String edition = request.getParameter("edition");
    int categoryId = Integer.parseInt(request.getParameter("category_id"));
    int totalCopies = Integer.parseInt(request.getParameter("total_copies"));
    int availableCopies = Integer.parseInt(request.getParameter("available_copies"));

    boolean updateSuccess = false; // Flag to track update success

    try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
         PreparedStatement pstmt = conn.prepareStatement(
            "UPDATE Books SET title = ?, author = ?, publisher = ?, edition = ?, category_id = ?, total_copies = ?, available_copies = ? WHERE book_id = ?")) {

        pstmt.setString(1, title);
        pstmt.setString(2, author);
        pstmt.setString(3, publisher);
        pstmt.setString(4, edition);
        pstmt.setInt(5, categoryId);
        pstmt.setInt(6, totalCopies);
        pstmt.setInt(7, availableCopies);
        pstmt.setInt(8, Integer.parseInt(bookId));

        int rowsAffected = pstmt.executeUpdate();
        if (rowsAffected > 0) {
            updateSuccess = true; // Set success flag
        }
    } catch (SQLException e) {
        out.println("Error updating book: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Book Result</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
            text-align: center;
        }
        .message {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
            padding: 15px;
            border-radius: 5px;
            display: inline-block;
            margin-top: 20px;
        }
        .error {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            text-decoration: none;
            color: #337ab7;
        }
    </style>
</head>
<body>
    <% if (updateSuccess) { %>
        <div class="message">
            <h2>Success!</h2>
            <p>Book updated successfully!</p>
        </div>
        <script type="text/javascript">
            setTimeout(function() {
                window.location.href = "../../pages/librarian/librarian_home.jsp"; // Redirect after 2 seconds
            }, 2000);
        </script>
    <% } else { %>
        <div class="message error">
            <h2>Error!</h2>
            <p>Failed to update book. Please try again.</p>
            <a href="../../pages/librarian/librarian_home.jsp">Go back to home</a>
        </div>
    <% } %>
</body>
</html>
