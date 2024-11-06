<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/xe";
    String dbUsername = "system";
    String dbPassword = "root";

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

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Advanced Book Search</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            background: linear-gradient(to right, #e3f2fd, #ffffff); /* Light blue to white gradient */
        }

        .container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 800px;
            margin-top: 50px;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 26px;
            text-align: center;
        }

        .search-form {
            display: flex;
            flex-direction: column;
            margin-bottom: 20px;
        }

        .search-form label {
            margin-top: 10px;
            font-weight: bold;
        }

        .search-form input, .search-form select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            margin-top: 5px;
            font-size: 16px;
        }

        .search-form input[type="submit"] {
            background-color: #4CAF50; /* Green */
            color: white;
            border: none;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 15px;
            font-size: 16px;
        }

        .search-form input[type="submit"]:hover {
            background-color: #45a049;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .action-buttons form {
            display: inline;
        }

        .action-buttons input {
            padding: 6px 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
            font-size: 14px;
        }

        .update-button {
            background-color: #007bff; /* Blue */
            color: white;
        }

        .delete-button {
            background-color: #dc3545; /* Red */
            color: white;
        }

        .issue-button {
            background-color: #ffc107; /* Yellow */
            color: black;
        }

        .action-buttons input:hover {
            opacity: 0.8;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Advanced Book Search</h2>
    <form action="search.jsp" method="get" class="search-form">
        <label for="title">Title:</label>
        <input type="text" name="title" value="<%= title != null ? title : "" %>" id="title">

        <label for="author">Author:</label>
        <input type="text" name="author" value="<%= author != null ? author : "" %>" id="author">

        <label for="publisher">Publisher:</label>
        <input type="text" name="publisher" value="<%= publisher != null ? publisher : "" %>" id="publisher">

        <label for="edition">Edition:</label>
        <input type="text" name="edition" value="<%= edition != null ? edition : "" %>" id="edition">

        <label for="category">Category:</label>
        <select name="category" id="category">
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
        </select>
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
    <table>
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
            <td class="action-buttons">
                <% if ("librarian".equalsIgnoreCase(role)) { %>
                    <form action="librarian/update_book.jsp" method="post">
                        <input type="hidden" name="book_id" value="<%= rs.getInt("book_id") %>">
                        <input type="submit" value="Update" class="update-button">
                    </form>
                    <form action="librarian/delete_book.jsp" method="post">
                        <input type="hidden" name="book_id" value="<%= rs.getInt("book_id") %>">
                        <input type="submit" value="Delete" class="delete-button">
                    </form>
                <% } else { %>
                    <form action="student_faculty/issue_book.jsp" method="post">
                        <input type="hidden" name="book_id" value="<%= rs.getInt("book_id") %>">
                        <input type="submit" value="Issue Book" class="issue-button">
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
</div>

</body>
</html>