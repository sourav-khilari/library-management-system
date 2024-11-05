<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";  // Using service name
    String dbUsername = "SYSTEM";                                  // Oracle DB username
    String dbPassword = "skoracle";                                // Oracle DB password

    // Retrieve form parameters
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String publisher = request.getParameter("publisher");
    String edition = request.getParameter("edition");
    String categoryId = request.getParameter("category_id");
    String totalCopies = request.getParameter("total_copies");

    // Validate the inputs
    if (title == null || title.isEmpty() || categoryId == null || categoryId.isEmpty() || totalCopies == null || totalCopies.isEmpty()) {
        out.println("Title, category, and total copies are required fields.<br>");
    } else {
        // Using try-with-resources to manage resources automatically
        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
             PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO Books (book_id, title, author, publisher, edition, category_id, total_copies, available_copies) " +
                "VALUES (Books_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?)")) {
            
            // Set parameters
            pstmt.setString(1, title);
            pstmt.setString(2, author);
            pstmt.setString(3, publisher);
            pstmt.setString(4, edition);
            pstmt.setInt(5, Integer.parseInt(categoryId)); // category_id as an integer
            pstmt.setInt(6, Integer.parseInt(totalCopies));
            pstmt.setInt(7, Integer.parseInt(totalCopies)); // available_copies equals total_copies

            // Execute the update
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("Book added successfully!<br>");
            } else {
                out.println("Failed to add book.<br>");
            }
        } catch (SQLException e) {
            out.println("Error saving book: " + e.getMessage() + "<br>");
        } catch (NumberFormatException e) {
            out.println("Invalid number format for category or total copies.<br>");
        } catch (Exception e) {
            out.println("An unexpected error occurred: " + e.getMessage() + "<br>");
        }
    }
%>
