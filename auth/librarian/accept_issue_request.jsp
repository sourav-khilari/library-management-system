<%@ page import="java.sql.*, java.util.Calendar" %>
<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
    String dbUsername = "SYSTEM";
    String dbPassword = "skoracle";

    // Retrieve userId and bookId from the form
    String userId = request.getParameter("userId");
    int bookId = Integer.parseInt(request.getParameter("bookId"));
    String action = request.getParameter("action");

    String fineMessage = "";
    boolean canProcess = true;

    // Database connection objects
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

        if ("accept".equals(action)) {
            // Start a transaction
            conn.setAutoCommit(false);

            // Check the number of available copies of the book
            pstmt = conn.prepareStatement("SELECT available_copies FROM Books WHERE book_id = ?");
            pstmt.setInt(1, bookId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                int availableCopies = rs.getInt("available_copies");

                if (availableCopies > 0) {
                    // Update the book status to "issued"
                    pstmt = conn.prepareStatement("UPDATE Issued_Books SET STATUS = 'issued' WHERE USER_ID = ? AND BOOK_ID = ?");
                    pstmt.setString(1, userId);
                    pstmt.setInt(2, bookId);
                    pstmt.executeUpdate();

                    // Decrease the available copies in the Books table
                    pstmt = conn.prepareStatement("UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = ?");
                    pstmt.setInt(1, bookId);
                    pstmt.executeUpdate();

                    // Increment the user's issued book count
                    pstmt = conn.prepareStatement("UPDATE Users SET issued_book_count = issued_book_count + 1 WHERE user_id = ?");
                    pstmt.setString(1, userId);
                    pstmt.executeUpdate();

                    // Log the transaction into the Transaction_Log table
                    pstmt = conn.prepareStatement("INSERT INTO Transaction_Log (TRANSACTION_ID, USER_ID, BOOK_ID, TRANSACTION_TYPE, TRANSACTION_DATE) VALUES (SEQ_TRANSACTION_ID.NEXTVAL, ?, ?, 'issue', ?)");
                    pstmt.setString(1, userId);
                    pstmt.setInt(2, bookId);
                    pstmt.setTimestamp(3, new java.sql.Timestamp(System.currentTimeMillis()));
                    pstmt.executeUpdate();

                    fineMessage = "Book issued successfully.";
                } else {
                    fineMessage = "No available copies of the book.";
                    canProcess = false;
                }
            }
        } else if ("decline".equals(action)) {
            // If the action is "decline", update the status to "declined"
            pstmt = conn.prepareStatement("UPDATE Issued_Books SET STATUS = 'declined' WHERE USER_ID = ? AND BOOK_ID = ?");
            pstmt.setString(1, userId);
            pstmt.setInt(2, bookId);
            pstmt.executeUpdate();
            
            fineMessage = "Request declined.";
        }

        // Commit transaction if everything is successful
        if (canProcess) {
            conn.commit();
        } else {
            conn.rollback();
        }

    } catch (SQLException e) {
        fineMessage = "An error occurred: " + e.getMessage();
        try {
            if (conn != null) conn.rollback();
        } catch (SQLException se) {
            fineMessage += " Rollback failed: " + se.getMessage();
        }
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }

    out.println("<p>" + fineMessage + "</p>");
    out.println("<a href='../../pages/librarian/accept_request.jsp'>Go back to requests</a>");
%>
