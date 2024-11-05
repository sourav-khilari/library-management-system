<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    String bookId = request.getParameter("book_id");
    String action = request.getParameter("action");

    // If the action is to confirm deletion, proceed with deletion logic
    if ("confirm".equals(action)) {
        // Database connection details
        String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/xe";
        String dbUsername = "system";
        String dbPassword = "root";

        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement("DELETE FROM Books WHERE book_id = ?")) {

            pstmt.setInt(1, Integer.parseInt(bookId));
            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Book deleted successfully
                out.println("<script>alert('Book deleted successfully! Redirecting to home...');</script>");
            } else {
                // Failed to delete book
                out.println("<script>alert('Failed to delete book. Please try again. Redirecting to home...');</script>");
            }
        } catch (SQLException e) {
            out.println("<script>alert('Error deleting book: " + e.getMessage() + ". Redirecting to home...');</script>");
        }

        // Redirect to home after showing alert
        out.println("<script>setTimeout(function() { window.location.href = 'librarian_home.jsp'; }, 3000);</script>");
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
                window.location.href = "librarian_home.jsp"; // Redirect to home if cancelled
            }
        }
    </script>
</head>
<body onload="confirmDelete()">
</body>
</html>

<%
    } // End of if-else statement
%>
