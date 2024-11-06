<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Check if user is a librarian
    String role = (String) session.getAttribute("role");
    if (!"librarian".equals(role)) {
        response.sendRedirect("../login_p.jsp");  // Redirect if user is not a librarian
        return;
    }

    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/xe";
    String dbUsername = "system";
    String dbPassword = "root";

    // Get search parameters
    String username = request.getParameter("username");
    String userId = request.getParameter("user_id");
    String email = request.getParameter("email");
    boolean showAll = "true".equals(request.getParameter("show_all"));

    // Query preparation
    String query = "SELECT * FROM Users WHERE 1=1";
    if (username != null && !username.isEmpty()) {
        query += " AND username LIKE ?";
    }
    if (userId != null && !userId.isEmpty()) {
        query += " AND user_id = ?";
    }
    if (email != null && !email.isEmpty()) {
        query += " AND email LIKE ?";
    }

    // HTML and Form
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Delete User</title>
    <link rel="stylesheet" type="text/css" href="../../css/delete_member.css"> <!-- Include the existing CSS file -->
    <script>
        function confirmDelete(userId) {
            if (confirm("Are you sure you want to delete this user?")) {
                window.location.href = "../../auth/librarian/delete_member.jsp?user_id=" + userId;
            }
        }

        function clearFieldsAndShowAll() {
            // Clear the input fields
            document.getElementById("username").value = "";
            document.getElementById("user_id").value = "";
            document.getElementById("email").value = "";
            // Set show_all parameter to true and submit the form
            document.getElementById("show_all").value = "true";
            document.getElementById("searchForm").submit();
        }
    </script>
</head>
<body>
    <div class="container"> <!-- Add a container for better layout -->
        <h2>Delete User</h2>
        <form id="searchForm" method="get" action="delete_member.jsp">
            <div class="input-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" value="<%= username != null ? username : "" %>">
            </div>

            <div class="input-group">
                <label for="user_id">User ID:</label>
                <input type="text" id="user_id" name="user_id" value="<%= userId != null ? userId : "" %>">
            </div>

            <div class="input-group">
                <label for="email">Email:</label>
                <input type="text" id="email" name="email" value="<%= email != null ? email : "" %>">
            </div>

            <div class="button-group">
                <button type="submit" class="btn">Search</button>
                <button type="button" class="btn btn-secondary" onclick="clearFieldsAndShowAll()">Show All Users</button>
            </div>
            <input type="hidden" id="show_all" name="show_all" value="false">
        </form>

        <%
            if (showAll || (username != null || userId != null || email != null)) {
                try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
                     PreparedStatement pstmt = conn.prepareStatement(query)) {

                    int paramIndex = 1;
                    if (username != null && !username.isEmpty()) {
                        pstmt.setString(paramIndex++, "%" + username + "%");
                    }
                    if (userId != null && !userId.isEmpty()) {
                        pstmt.setString(paramIndex++, userId);
                    }
                    if (email != null && !email.isEmpty()) {
                        pstmt.setString(paramIndex++, "%" + email + "%");
                    }

                    ResultSet rs = pstmt.executeQuery();
        %>

        <table class="user-table">
            <thead>
                <tr>
                    <th>Action</th>
                    <th>User ID</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Role</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        String currentUserId = rs.getString("user_id");
                        String currentUsername = rs.getString("username");
                        String currentEmail = rs.getString("email");
                        String currentUserRole = rs.getString("user_role");
                %>
                <tr>
                    <td><button class="btn btn-danger" onclick="confirmDelete('<%= currentUserId %>')">Delete</button></td>
                    <td><%= currentUserId %></td>
                    <td><%= currentUsername %></td>
                    <td><%= currentEmail %></td>
                    <td><%= currentUserRole %></td>
                </tr>
                <%
                    }
                } catch (SQLException e) {
                    out.println("Error retrieving users: " + e.getMessage());
                }
            }
        %>
            </tbody>
        </table>
    </div>
</body>
</html>
