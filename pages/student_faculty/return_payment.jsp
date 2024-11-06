<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Return and Clear Fine</title>
    <style>
        /* Basic styles */
        body { font-family: Arial, sans-serif; }
        .container { width: 80%; margin: auto; }
        .book-item { border-bottom: 1px solid #ddd; padding: 10px; display: flex; justify-content: space-between; }
        .book-details { flex: 3; }
        .actions { flex: 2; display: flex; gap: 10px; }
        .btn { padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; }
        .btn-return { background-color: #4CAF50; color: white; }
        .btn-pay { background-color: #f44336; color: white; }
        .btn-disabled { background-color: #ddd; color: #aaa; cursor: not-allowed; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Return and Clear Fine</h1>
        
        <%
            // Assume `userId` is retrieved from the session for the logged-in user
            String userId = (String) session.getAttribute("userId");
            
            // Database connection setup
            String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"; // Using service name
            String dbUsername = "SYSTEM";                                  // Oracle DB username
            String dbPassword = "skoracle";               
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

                // Query to get issued books, fine status, and book details
                String query = "SELECT i.ISSUE_ID, i.BOOK_ID, i.ISSUE_DATE, i.DUE_DATE, i.RETURN_DATE, i.STATUS, i.FINE, i.FINE_ACCEPTED, " +
                               "b.TITLE, b.AUTHOR " +
                               "FROM ISSUED_BOOKS i " +
                               "JOIN BOOKS b ON i.BOOK_ID = b.BOOK_ID " +
                               "WHERE i.USER_ID = ? ";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, userId);
                rs = pstmt.executeQuery();
                
                // Display books with action buttons
                while (rs.next()) {
                    String issueId = rs.getString("ISSUE_ID");
                    String bookId = rs.getString("BOOK_ID");
                    String title = rs.getString("TITLE");
                    String author = rs.getString("AUTHOR");
                    String issueDate = rs.getString("ISSUE_DATE");
                    String dueDate = rs.getString("DUE_DATE");
                    String status = rs.getString("STATUS");
                    double fine = rs.getDouble("FINE");
                    String fineAccepted = rs.getString("FINE_ACCEPTED");
                    boolean isFineAccepted = "Y".equalsIgnoreCase(fineAccepted);

                    // Show each book's details
        %>
                    <div class="book-item">
                        <div class="book-details">
                            <strong>Title:</strong> <%= title %> <br>
                            <strong>Author:</strong> <%= author %> <br>
                            <strong>Issue Date:</strong> <%= issueDate %> <br>
                            <strong>Due Date:</strong> <%= dueDate %> <br>
                            <strong>Fine Amount:</strong> $<%= fine %> <br>
                            <strong>Status:</strong> <%= status %> <br>
                        </div>
                        <div class="actions">
                            <!-- Pay Fine button, only if there is a fine and it hasn't been accepted -->
                            <% if (fine > 0 && !isFineAccepted) { %>
                                <form action="pay_fine.jsp" method="post" style="display: inline;">
                                    <input type="hidden" name="issueId" value="<%= issueId %>">
                                    <button type="submit" class="btn btn-pay">Pay Fine</button>
                                </form>
                            <% } else if (fine > 0 && isFineAccepted) { %>
                                <!-- Fine paid message if fine is accepted -->
                                <button class="btn btn-disabled" disabled>Fine Cleared</button>
                            <% } else { %>
                                <!-- No fine message -->
                                <button class="btn btn-disabled" disabled>No Fine</button>
                            <% } %>

                            <!-- Return button, only enabled if fine is zero or fine is paid and status is not 'Pending' or 'Declined' -->
                            <% if ((fine == 0 || isFineAccepted) && !"Pending".equalsIgnoreCase(status) && !"Declined".equalsIgnoreCase(status)) { %>
                                <form action="return_req.jsp" method="post" style="display: inline;">
                                    <input type="hidden" name="issueId" value="<%= issueId %>">
                                    <button type="submit" class="btn btn-return">Return</button>
                                </form>
                            <% } else { %>
                                <!-- Disabled return button if there is an unpaid fine or status is 'Pending' or 'Declined' -->
                                <button class="btn btn-disabled" disabled>Return</button>
                            <% } %>
                        </div>
                    </div>
        <%
                }
            } catch (SQLException | ClassNotFoundException e) {
                out.println("Error: " + e.getMessage());
            } finally {
                // Close resources
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>
    </div>
</body>
</html> 
