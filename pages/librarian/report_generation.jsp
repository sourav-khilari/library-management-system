<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Transaction Report</title>
</head>
<body>
    <h1>Transaction Report</h1>

    <%
        // Database connection details
        String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
        String dbUsername = "SYSTEM";
        String dbPassword = "skoracle";

        try {
            // Load Oracle JDBC driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Query to fetch transaction details
            String query = "SELECT t.TRANSACTION_ID, t.USER_ID, u.USERNAME, t.BOOK_ID, b.title, " +
                           "t.TRANSACTION_TYPE, t.TRANSACTION_DATE " +
                           "FROM TRANSACTION_LOG t " +
                           "JOIN USERS u ON t.USER_ID = u.USER_ID " +
                           "JOIN ISSUED_BOOKS ib ON t.BOOK_ID = ib.BOOK_ID " +
                           "JOIN BOOKS b ON ib.BOOK_ID = b.BOOK_ID " +
                           "ORDER BY t.TRANSACTION_DATE DESC";

            // Establish connection to the database
            try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
                 Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {

                // Start the HTML table for the report
                out.println("<table border='1'>");
                out.println("<tr>");
                out.println("<th>Transaction ID</th>");
                out.println("<th>User ID</th>");
                out.println("<th>Username</th>");
                out.println("<th>Book ID</th>");
                out.println("<th>Book Name</th>");
                out.println("<th>Transaction Type</th>");
                out.println("<th>Transaction Date</th>");
                out.println("</tr>");

                // Process the result set and display transaction details
                while (rs.next()) {
                    String transactionId = rs.getString("TRANSACTION_ID");
                    String userId = rs.getString("USER_ID");
                    String username = rs.getString("USERNAME");
                    String bookId = rs.getString("BOOK_ID");
                    String bookName = rs.getString("title");
                    String transactionType = rs.getString("TRANSACTION_TYPE");
                    Date transactionDate = rs.getDate("TRANSACTION_DATE");

                    out.println("<tr>");
                    out.println("<td>" + transactionId + "</td>");
                    out.println("<td>" + userId + "</td>");
                    out.println("<td>" + username + "</td>");
                    out.println("<td>" + bookId + "</td>");
                    out.println("<td>" + bookName + "</td>");
                    out.println("<td>" + transactionType + "</td>");
                    out.println("<td>" + transactionDate + "</td>");
                    out.println("</tr>");
                }

                // End the table
                out.println("</table>");
            } catch (SQLException e) {
                out.println("<p>Error fetching transaction data: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        } catch (ClassNotFoundException e) {
            out.println("<p>Error loading the Oracle JDBC driver: " + e.getMessage() + "</p>");
            e.printStackTrace();
        }
    %>
</body>
</html>
