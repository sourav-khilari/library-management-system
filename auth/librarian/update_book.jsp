<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
    String dbUsername = "SYSTEM";
    String dbPassword = "skoracle";

    String bookId = request.getParameter("book_id");
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String publisher = request.getParameter("publisher");
    String edition = request.getParameter("edition");
    int categoryId = Integer.parseInt(request.getParameter("category_id"));
    int totalCopies = Integer.parseInt(request.getParameter("total_copies"));
    int availableCopies = Integer.parseInt(request.getParameter("available_copies"));

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
            out.println("Book updated successfully!");
        } else {
            out.println("Failed to update book.");
        }
    } catch (SQLException e) {
        out.println("Error updating book: " + e.getMessage());
    }
%>
