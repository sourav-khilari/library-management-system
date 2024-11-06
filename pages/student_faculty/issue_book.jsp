<%@ page import="java.sql.*, java.util.Calendar" %>
<%
    // Database connection details (replace with your actual values)
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"; // Using service name
    String dbUsername = "SYSTEM";                                  // Oracle DB username
    String dbPassword = "skoracle";                                // Oracle DB password

    // Retrieve the user ID and book ID
    String userId = (String) session.getAttribute("userId");
    String bookIdParam = request.getParameter("book_id");
    boolean canIssue = true;
    String fineMessage = "";

    // Validate if bookId is a valid integer
    int bookId = -1; // Default value for an invalid book ID
    try {
        if (bookIdParam != null && !bookIdParam.isEmpty()) {
            bookId = Integer.parseInt(bookIdParam);
        } else {
            fineMessage = "Invalid book ID.";
            canIssue = false;
        }
    } catch (NumberFormatException e) {
        fineMessage = "Invalid book ID format.";
        canIssue = false;
    }

    if (bookId == -1) {
        canIssue = false;  // Prevent further operations if bookId is invalid
    }

    // Database connection objects
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        if (canIssue) {
            // Establish a connection to the database
            conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

            // Check if the user has any pending fines
            pstmt = conn.prepareStatement("SELECT FINE FROM Issued_Books WHERE USER_ID = ? AND STATUS = 'issued' AND FINE_ACCEPTED = 'N'");
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next() && rs.getDouble("FINE") > 0) {
                fineMessage = "You have an outstanding fine. You cannot issue a new book until the fine is cleared.";
                canIssue = false;
            }
            rs.close();
            pstmt.close();

            if (canIssue) {
                // Check how many books the user has already issued (limit to 4 books)
                pstmt = conn.prepareStatement("SELECT COUNT(*) FROM Issued_Books WHERE USER_ID = ? AND STATUS = 'issued'");
                pstmt.setString(1, userId);
                rs = pstmt.executeQuery();
                if (rs.next() && rs.getInt(1) >= 4) {
                    fineMessage = "You cannot issue more than 4 books.";
                    canIssue = false;
                }
                rs.close();
                pstmt.close();
            }

            if (canIssue) {
                // Check if there are available copies of the book
                pstmt = conn.prepareStatement("SELECT available_copies FROM Books WHERE book_id = ?");
                pstmt.setInt(1, bookId);
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    int availableCopies = rs.getInt("available_copies");
                    if (availableCopies <= 0) {
                        fineMessage = "This book is currently not available.";
                        canIssue = false;
                    }
                }
                rs.close();
                pstmt.close();
            }

            // If all conditions are met, issue the book
            if (canIssue) {
                pstmt = conn.prepareStatement("INSERT INTO Issued_Books (ISSUE_ID, USER_ID, BOOK_ID, ISSUE_DATE, DUE_DATE, STATUS) VALUES (SEQ_ISSUE_ID.NEXTVAL, ?, ?, ?, ?, 'pending')");

                pstmt.setString(1, userId);
                pstmt.setInt(2, bookId);

                // Set the issue date and due date (adjust as necessary)
                java.util.Date today = new java.util.Date();
                pstmt.setDate(3, new java.sql.Date(today.getTime()));

                // Set a default due date, for example, 14 days from now
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(today);
                calendar.add(Calendar.DAY_OF_YEAR, 14); // 14 days due date
                pstmt.setDate(4, new java.sql.Date(calendar.getTimeInMillis()));

                pstmt.executeUpdate();
                fineMessage = "The book issue request has been submitted and is pending librarian approval.";
            }

        }
    } catch (SQLException e) {
        fineMessage = "An error occurred while processing your request: " + e.getMessage();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }

    // Display the fine message or error
    out.println("<p>" + fineMessage + "</p>");
%>
