<%@ page import="java.sql.*, java.util.Calendar" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
    String dbUsername = "SYSTEM";
    String dbPassword = "skoracle";  

    // Database connection objects
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // Establish a connection to the database
        conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

        // Query to retrieve all pending book requests
        String query = "SELECT ib.USER_ID, ib.BOOK_ID, u.EMAIL, u.USER_ID, b.title " +
                       "FROM Issued_Books ib " +
                       "JOIN Users u ON ib.USER_ID = u.USER_ID " +
                       "JOIN Books b ON ib.BOOK_ID = b.BOOK_ID " +
                       "WHERE ib.STATUS = 'pending'";

        pstmt = conn.prepareStatement(query);
        rs = pstmt.executeQuery();

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Book Requests</title>
    <link rel="stylesheet" href="../../css/accept_request.css"> <!-- Link to external CSS file -->
</head>
<body>

    <div class="container">
        <h2>Pending Book Requests</h2>
        <table class="request-table">
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Email</th>
                    <th>Book Name</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        String userId = rs.getString("USER_ID");
                        String email = rs.getString("EMAIL");
                        String bookName = rs.getString("title");
                        int bookId = rs.getInt("BOOK_ID");
                %>
                <tr>
                    <td><%= userId %></td>
                    <td><%= email %></td>
                    <td><%= bookName %></td>
                    <td>
                        <form action='../../auth/librarian/accept_issue_request.jsp' method='post'>
                            <input type='hidden' name='userId' value='<%= userId %>'>
                            <input type='hidden' name='bookId' value='<%= bookId %>'>
                            <button type='submit' name='action' value='accept' class='btn accept-btn'>Accept</button>
                            <button type='submit' name='action' value='decline' class='btn decline-btn'>Decline</button>
                        </form>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
    </div>

</body>
</html>

<%
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
