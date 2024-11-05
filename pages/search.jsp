<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
    String dbUsername = "SYSTEM";
    String dbPassword = "skoracle";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    // Retrieve form parameters
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String publisher = request.getParameter("publisher");
    String edition = request.getParameter("edition");
    String category = request.getParameter("category");

    // Retrieve user role and username from the session
    String role = (String) session.getAttribute("role"); // "librarian", "student", "faculty"
    String username = (String) session.getAttribute("username");

    // Retrieve categories for the dropdown
    List<String> categories = new ArrayList<>();
    try {
        conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
        pstmt = conn.prepareStatement("SELECT category_name FROM Category");
        rs = pstmt.executeQuery();
        while (rs.next()) {
            categories.add(rs.getString("category_name"));
        }
        rs.close();
        pstmt.close();
    } catch (SQLException e) {
        out.println("Error fetching categories: " + e.getMessage());
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
    }
%>

<!-- Search Form -->
<h2>Advanced Book Search</h2>
<form action="search.jsp" method="get">
    Title: <input type="text" name="title" value="<%= title != null ? title : "" %>"><br>
    Author: <input type="text" name="author" value="<%= author != null ? author : "" %>"><br>
    Publisher: <input type="text" name="publisher" value="<%= publisher != null ? publisher : "" %>"><br>
    Edition: <input type="text" name="edition" value="<%= edition != null ? edition : "" %>"><br>
    Category:
    <select name="category">
        <option value="">--Select Category--</option>
        <%
            for (String cat : categories) {
                if (cat.equals(category)) {
                    out.println("<option value='" + cat + "' selected>" + cat + "</option>");
                } else {
                    out.println("<option value='" + cat + "'>" + cat + "</option>");
                }
            }
        %>
    </select><br>
    <input type="submit" value="Search">
</form>

<% 
    // Display search results only if form is submitted
    if (title != null || author != null || publisher != null || edition != null || category != null) {

        // Build SQL query based on input parameters
        StringBuilder query = new StringBuilder("SELECT * FROM Books WHERE 1=1");
        if (title != null && !title.isEmpty()) query.append(" AND title LIKE ?");
        if (author != null && !author.isEmpty()) query.append(" AND author LIKE ?");
        if (publisher != null && !publisher.isEmpty()) query.append(" AND publisher LIKE ?");
        if (edition != null && !edition.isEmpty()) query.append(" AND edition = ?");
        if (category != null && !category.isEmpty()) query.append(" AND category_id = (SELECT category_id FROM Category WHERE category_name = ?)");

        try {
            pstmt = conn.prepareStatement(query.toString());

            int index = 1;
            if (title != null && !title.isEmpty()) pstmt.setString(index++, "%" + title + "%");
            if (author != null && !author.isEmpty()) pstmt.setString(index++, "%" + author + "%");
            if (publisher != null && !publisher.isEmpty()) pstmt.setString(index++, "%" + publisher + "%");
            if (edition != null && !edition.isEmpty()) pstmt.setString(index++, edition);
            if (category != null && !category.isEmpty()) pstmt.setString(index++, category);

            rs = pstmt.executeQuery();
%>

<!-- Display Search Results Table -->
<h2>Search Results</h2>
<table border="1">
    <tr>
        <th>Title</th>
        <th>Author</th>
        <th>Publisher</th>
        <th>Edition</th>
        <th>Available Copies</th>
        <th>Total Copies</th>
        <th>Actions</th>
    </tr>
<%
            while (rs.next()) {
%>
    <tr>
        <td><%= rs.getString("title") %></td>
        <td><%= rs.getString("author") %></td>
        <td><%= rs.getString("publisher") %></td>
        <td><%= rs.getString("edition") %></td>
        <td><%= rs.getInt("available_copies") %></td>
        <td><%= rs.getInt("total_copies") %></td>
        <td>
            <% if ("librarian".equalsIgnoreCase(role)) { %>
                <form action="librarian/update_book.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="book_id" value="<%= rs.getInt("book_id") %>">
                    <input type="submit" value="Update">
                </form>
                <form action="librarian/delete_book.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="book_id" value="<%= rs.getInt("book_id") %>">
                    <input type="submit" value="Delete">
                </form>
            <% } else { %>
                <form action="issue_book.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="book_id" value="<%= rs.getInt("book_id") %>">
                    <input type="submit" value="Issue Book">
                </form>
            <% } %>
        </td>
    </tr>
<%
            }
%>
</table>

<%
        } catch (SQLException e) {
            out.println("Error retrieving books: " + e.getMessage());
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
            if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
            if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
        }
    } // End of search result display condition
%>
