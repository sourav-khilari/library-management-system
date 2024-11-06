<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Process Fine Request</title>
</head>
<body>
    <%
        // Database connection
        String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
        String dbUsername = "SYSTEM";
        String dbPassword = "skoracle";

        // Fetching the form parameters
        String issueId = request.getParameter("issueId");
        String action = request.getParameter("action");

        // Declare new status variables
        String fineStatus = "Declined"; // Default action
        double newFineAmount = 0;

        if ("accept".equalsIgnoreCase(action)) {
            fineStatus = "Y"; // Mark as accepted
            newFineAmount = 0; // Set fine to 0 after accepting
        }

        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establishing connection
            try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword)) {
                
                // Prepare SQL to update the fine status and fine amount
                String updateQuery = "UPDATE ISSUED_BOOKS SET FINE_STATUS = ?, FINE_AMOUNT = ? WHERE ISSUE_ID = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {
                    pstmt.setString(1, fineStatus); // Set FINE_STATUS (Y for accepted)
                    pstmt.setDouble(2, newFineAmount); // Set FINE_AMOUNT to 0 for accepted requests
                    pstmt.setString(3, issueId); // Set ISSUE_ID for the record to update
                    pstmt.executeUpdate();
                    
                    // Log the transaction in the transaction_log table
                    String userId = ""; // Retrieve userId based on the issueId
                    String logAction = "Accepted"; // Default log action
                    if ("decline".equalsIgnoreCase(action)) {
                        logAction = "Declined"; // If the action is "decline"
                    }

                    // Retrieve the userId to log the transaction
                    String userQuery = "SELECT USER_ID,BOOK_ID FROM ISSUED_BOOKS WHERE ISSUE_ID = ?";
                    String bookid;
                    try (PreparedStatement userStmt = conn.prepareStatement(userQuery)) {
                        userStmt.setString(1, issueId);
                        try (ResultSet rs = userStmt.executeQuery()) {
                            if (rs.next()) {
                                userId = rs.getString("USER_ID");
                                bookid=rs.getString("BOOK_ID");
                            } else {
                                out.println("<p>No user found for Issue ID: " + issueId + "</p>");
                                return;  // Exit if no user is found
                            }
                        }
                    } catch (SQLException e) {
                        out.println("<p>Error fetching user details: " + e.getMessage() + "</p>");
                        return;
                    }

                    // Insert transaction log with transaction ID from sequence
                    String insertLogQuery = "INSERT INTO TRANSACTION_LOG (TRANSACTION_ID, BOOK_ID, USER_ID, TRANSACTION_TYPE, TRANSACTION_DATE) VALUES (SEQ_TRANSACTION_ID.NEXTVAL, ?, ?, ?, CURRENT_TIMESTAMP)";
                    try (PreparedStatement logStmt = conn.prepareStatement(insertLogQuery)) {
                        logStmt.setString(1, bookid);
                        logStmt.setString(2, userId);
                        logStmt.setString(3, logAction);
                        logStmt.executeUpdate();
                    }

                    // Provide feedback to the user
                    if ("accept".equalsIgnoreCase(action)) {
                        out.println("<p>Request accepted for Issue ID: " + issueId + ". Fine is now 0.</p>");
                    } else {
                        out.println("<p>Request declined for Issue ID: " + issueId + ".</p>");
                    }
                }
            } catch (SQLException e) {
                out.println("<p>Error processing the request: " + e.getMessage() + "</p>");
            }
        } catch (ClassNotFoundException e) {
            out.println("<p>Error loading Oracle JDBC driver: " + e.getMessage() + "</p>");
        }
    %>
</body>
</html>
