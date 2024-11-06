<%@ page import="java.sql.*, java.util.Calendar" %>
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

        // Display pending requests to the librarian
        out.println("<h2>Pending Book Requests</h2>");
        out.println("<table border='1'>");
        out.println("<tr><th>User ID</th><th>Email</th><th>Book Name</th><th>Actions</th></tr>");

        while (rs.next()) {
            String userId = rs.getString("USER_ID");
            String email = rs.getString("EMAIL");
            String bookName = rs.getString("title");
            int bookId = rs.getInt("BOOK_ID");

            out.println("<tr>");
            out.println("<td>" + userId + "</td>");
            out.println("<td>" + email + "</td>");
            out.println("<td>" + bookName + "</td>");
            out.println("<td>");
            out.println("<form action='../../auth/librarian/accept_issue_request.jsp' method='post'>");
            out.println("<input type='hidden' name='userId' value='" + userId + "'>");
            out.println("<input type='hidden' name='bookId' value='" + bookId + "'>");
            out.println("<button type='submit' name='action' value='accept'>Accept</button>");
            out.println("<button type='submit' name='action' value='decline'>Decline</button>");
            out.println("</form>");
            out.println("</td>");
            out.println("</tr>");
        }
        out.println("</table>");

    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
