<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.io.*" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
    String dbUsername = "SYSTEM";
    String dbPassword = "skoracle";                                   // Oracle DB password

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
        out.println("<a href='../../pages/librarian/add_book.jsp'>Go back</a>");
    } else {
        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword)) {
            
            // Check if the book already exists
            String checkQuery = "SELECT COUNT(*) FROM Books WHERE title = ? AND author = ? AND publisher = ? AND edition = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkQuery)) {
                checkStmt.setString(1, title);
                checkStmt.setString(2, author);
                checkStmt.setString(3, publisher);
                checkStmt.setString(4, edition);
                
                ResultSet rs = checkStmt.executeQuery();
                rs.next();
                int count = rs.getInt(1);
                
                if (count > 0) {
                    // Book already exists
                    response.sendRedirect("../../pages/librarian/add_book.jsp?error=Book already exists.");
                    return; // Stop processing further
                }
            }
            
            // Prepare the insert statement if the book does not exist
            String insertQuery = "INSERT INTO Books (book_id, title, author, publisher, edition, category_id, total_copies, available_copies) " +
                                 "VALUES (Books_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(insertQuery)) {
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
                    // Show alert message and redirect
                    out.println("<html><head>");
                    out.println("<script type='text/javascript'>");
                    out.println("alert('Book added successfully!');"); // JavaScript alert
                    out.println("window.location.href='../../pages/librarian/librarian_home.jsp';"); // Redirect
                    out.println("</script>");
                    out.println("</head><body></body></html>");
                    return; // Stop further processing
                } else {
                    out.println("Failed to add book.<br>");
                }
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
