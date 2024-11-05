<%@ page import="java.sql.*" %>
<%
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"; // Using service name
    String dbUsername = "system"; // Oracle DB username
    String dbPassword = "root"; // Oracle DB password

    String name = request.getParameter("name");
    String author = request.getParameter("author");
    String publisher = request.getParameter("publisher");
    String title = request.getParameter("title");
    String categoryId = request.getParameter("category_id");

    boolean hasError = false;

    // Validate each field and set error messages if any are empty
    if (name == null || name.trim().isEmpty()) {
        request.setAttribute("nameError", "Name is required.");
        hasError = true;
    }
    if (author == null || author.trim().isEmpty()) {
        request.setAttribute("authorError", "Author is required.");
        hasError = true;
    }
    if (publisher == null || publisher.trim().isEmpty()) {
        request.setAttribute("publisherError", "Publisher is required.");
        hasError = true;
    }
    if (title == null || title.trim().isEmpty()) {
        request.setAttribute("titleError", "Title is required.");
        hasError = true;
    }
    if (categoryId == null || categoryId.trim().isEmpty()) {
        request.setAttribute("categoryError", "Category ID is required.");
        hasError = true;
    }

    if (hasError) {
        // If there is an error, forward back to the form with error messages
        request.getRequestDispatcher("bookadd.jsp").forward(request, response);
    } else {
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

            // Insert book into the database
            String sql = "INSERT INTO books (name, author, publisher, title, category_id) VALUES (?, ?, ?, ?, ?)";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, author);
            pstmt.setString(3, publisher);
            pstmt.setString(4, title);
            pstmt.setInt(5, Integer.parseInt(categoryId));

            pstmt.executeUpdate();
            out.println("<p>Book added successfully.</p>");

        } catch (SQLException e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                out.println("<p>Error closing resources: " + ex.getMessage() + "</p>");
            }
        }
    }
%>
