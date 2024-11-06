<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Approve/Reject Book Return</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .container { width: 80%; margin: auto; padding-top: 20px; }
        .message { padding: 15px; border-radius: 4px; margin-top: 20px; }
        .success { background-color: #4CAF50; color: white; }
        .error { background-color: #f44336; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <%
            String requestId = request.getParameter("requestId");
            String issueId = request.getParameter("issueId");
            String userId = request.getParameter("userId");
            String action = request.getParameter("action");

            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                // Set up the database connection
                String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
                String dbUsername = "SYSTEM";
                String dbPassword = "skoracle";
                Class.forName("oracle.jdbc.driver.OracleDriver");
                conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

                if ("approve".equals(action)) {
                    // Fetch details of the return request and book
                    String query = "SELECT i.BOOK_ID, i.FINE, i.STATUS, b.AVAILABLE_COPIES, u.ISSUED_BOOK_COUNT " +
                                   "FROM ISSUED_BOOKS i " +
                                   "JOIN BOOKS b ON i.BOOK_ID = b.BOOK_ID " +
                                   "JOIN USERS u ON i.USER_ID = u.USER_ID " +
                                   "WHERE i.ISSUE_ID = ? AND i.USER_ID = ?";
                    pstmt = conn.prepareStatement(query);
                    pstmt.setString(1, issueId);
                    pstmt.setString(2, userId);
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        double fine = rs.getDouble("FINE");
                        String status = rs.getString("STATUS");
                        int bookId = rs.getInt("BOOK_ID");
                        int availableCopies = rs.getInt("AVAILABLE_COPIES");
                        int issueBookCount = rs.getInt("ISSUED_BOOK_COUNT");

                        // Proceed if the book is not yet returned
                        if (!"Returned".equalsIgnoreCase(status)) {
                            // Update the book status to "Returned" and set return date
                            String returnDate = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

                            // Use TO_DATE function to convert the date string to Oracle's DATE format
                            String updateIssuedBooksQuery = "UPDATE ISSUED_BOOKS SET RETURN_DATE = SYSDATE, STATUS = 'Returned' WHERE ISSUE_ID = ?";
                            pstmt = conn.prepareStatement(updateIssuedBooksQuery);
                            pstmt.setString(1, issueId);  // Ensure the date is in 'YYYY-MM-DD' format
                            //pstmt.setString(2, issueId);
                            int issuedUpdateCount = pstmt.executeUpdate();

                            if (issuedUpdateCount > 0) {
                                // Update the BOOKS table: Increase available copy count
                                String updateBooksQuery = "UPDATE BOOKS SET AVAILABLE_COPIES = AVAILABLE_COPIES + 1 WHERE BOOK_ID = ?";
                                pstmt = conn.prepareStatement(updateBooksQuery);
                                pstmt.setInt(1, bookId);
                                pstmt.executeUpdate();

                                // Update USERS table: Decrease issue book count
                                String updateUsersQuery = "UPDATE USERS SET ISSUED_BOOK_COUNT = ISSUED_BOOK_COUNT - 1 WHERE USER_ID = ?";
                                pstmt = conn.prepareStatement(updateUsersQuery);
                                pstmt.setString(1, userId);
                                pstmt.executeUpdate();

                                // Insert transaction record into TRANSACTION_LOG
                                String transactionQuery = "INSERT INTO TRANSACTION_LOG (TRANSACTION_ID, USER_ID, BOOK_ID, TRANSACTION_TYPE, TRANSACTION_DATE) " +
                                                          "VALUES (TRANSACTION_SEQ.NEXTVAL, ?, ?, 'Return', SYSDATE)";
                                pstmt = conn.prepareStatement(transactionQuery);
                                pstmt.setString(1, userId);
                                pstmt.setInt(2, bookId);
                                pstmt.executeUpdate();

                                // Update the return request status to 'Approved'
                                String updateRequestStatus = "UPDATE RETURN_REQUESTS SET STATUS = 'Approved' WHERE REQUEST_ID = ?";
                                pstmt = conn.prepareStatement(updateRequestStatus);
                                pstmt.setString(1, requestId);
                                pstmt.executeUpdate();

                                out.println("<div class='message success'>The book return has been approved and processed successfully.</div>");
                            } else {
                                out.println("<div class='message error'>Error processing the return. Please try again later.</div>");
                            }
                        } else {
                            out.println("<div class='message error'>This book has already been returned.</div>");
                        }
                    } else {
                        out.println("<div class='message error'>No record found for the issueId and userId.</div>");
                    }
                } else if ("reject".equals(action)) {
                    // If the librarian rejects the return request
                    String updateRequestStatus = "UPDATE RETURN_REQUESTS SET STATUS = 'Rejected' WHERE REQUEST_ID = ?";
                    pstmt = conn.prepareStatement(updateRequestStatus);
                    pstmt.setString(1, requestId);
                    pstmt.executeUpdate();
                    out.println("<div class='message error'>The book return request has been rejected.</div>");
                }

            } catch (SQLException | ClassNotFoundException e) {
                out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>
    </div>
</body>
</html>
