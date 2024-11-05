<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String bookId = request.getParameter("book_id");
    String action = request.getParameter("action");

    if ("confirm".equals(action)) {
        // Database connection details
        String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
        String dbUsername = "SYSTEM";
        String dbPassword = "skoracle";

        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Books WHERE book_id = ?")) {

            pstmt.setInt(1, Integer.parseInt(bookId));
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("Book deleted successfully!");
            } else {
                out.println("Failed to delete book.");
            }
        } catch (SQLException e) {
            out.println("Error deleting book: " + e.getMessage());
        }
    } else {
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete Book</title>
    <script>
        function confirmDelete() {
            if (confirm("Are you sure you want to delete this book?")) {
                window.location.href = "delete_book.jsp?book_id=<%= bookId %>&action=confirm";
            } else {
                window.history.back();
            }
        }
    </script>
</head>
<body onload="confirmDelete()">
</body>
</html>

<% } %>
