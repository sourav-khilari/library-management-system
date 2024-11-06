<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Fine Payment Requests</title>
</head>
<body>
    <h1>Pending Fine Payment Requests</h1>

    <%
        // Database connection details
        String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
        String dbUsername = "SYSTEM";
        String dbPassword = "skoracle";

        try {
            // Load Oracle JDBC driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Query to fetch pending fine requests
            String query = "SELECT ib.ISSUE_ID, ib.USER_ID, ib.BOOK_ID, ib.FINE, u.EMAIL, u.USER_ROLE, u.ID " +
                           "FROM ISSUED_BOOKS ib " +
                           "JOIN USERS u ON ib.USER_ID = u.USER_ID " +
                           "WHERE ib.FINE_STATUS = 'Pending'";

            // Establish connection to the database
            try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {

                // Process the result set and display fine requests
                while (rs.next()) {
                    String issueId = rs.getString("ISSUE_ID");
                    String userId = rs.getString("USER_ID");
                    String bookId = rs.getString("BOOK_ID");
                    double fineAmount = rs.getDouble("FINE");
                    String email = rs.getString("EMAIL");
                    String role = rs.getString("ROLE");
                    String id = rs.getString("ID");
        %>
                    <div>
                        <p>User ID: <%= userId %></p>
                        <p>Book ID: <%= bookId %></p>
                        <p>Fine Amount: $<%= fineAmount %></p>
                        <p>Email: <%= email %></p>
                        <p>Role: <%= role %></p>
                        <p>ID: <%= id %></p>
                        <!-- Forms for Accepting or Declining fine payment requests -->
                        <form action="../../auth/librarian/fine_req.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="issueId" value="<%= issueId %>">
                            <input type="hidden" name="action" value="accept">
                            <button type="submit">Accept</button>
                        </form>
                        <form action="../../auth/librarian/fine_req.jsp" method="post" style="display: inline;">
                            <input type="hidden" name="issueId" value="<%= issueId %>">
                            <input type="hidden" name="action" value="decline">
                            <button type="submit">Decline</button>
                        </form>
                    </div>
                    <hr>
        <%
                } // End of while loop

                if (!rs.isBeforeFirst()) { // No results returned
        %>
                    <p>No pending fine payment requests found.</p>
        <%
                }
            } catch (SQLException e) {
                out.println("<p>Error fetching fine requests: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        } catch (ClassNotFoundException e) {
            out.println("<p>Error loading the Oracle JDBC driver: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>
</body>
</html>
