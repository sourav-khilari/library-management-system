<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.Calendar" %>

<%
    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/xe";
    String dbUsername = "system";
    String dbPassword = "root";

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
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Status</title>
    <meta http-equiv="refresh" content="5; url='../../pages/librarian/accept_request.jsp'"> <!-- Auto-redirect after 5 seconds -->
    <script>
        function showAlertAndRedirect() {
            alert('<%= fineMessage %>');
            setTimeout(function() {
                window.location.href = '../../pages/librarian/accept_request.jsp';
            }, 5000); // Redirect after 5 seconds
        }
    </script>

    <style>
        /* Reset some basic styles */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f6f7;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            position: relative;
        }

        .container {
            background-color: #fff;
            padding: 30px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 10px;
            width: 80%;
            max-width: 600px;
            text-align: center;
            z-index: 2;
            position: relative;
        }

        h2 {
            color: #27ae60;
            margin-bottom: 20px;
        }

        .fineMessage {
            font-size: 18px;
            color: #34495e;
            margin-bottom: 20px;
        }

        p {
            font-size: 16px;
            color: #7f8c8d;
        }

        /* Overlay for darkened background */
        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 1;
        }

        a {
            display: inline-block;
            background-color: #2ecc71;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 20px;
        }

        a:hover {
            background-color: #27ae60;
        }
    </style>
</head>
<body onload="showAlertAndRedirect()">

    <div class="overlay"></div> <!-- Overlay for better visual appeal -->

    <div class="container">
        <h2>Status Update</h2>
        <p class="fineMessage"><%= fineMessage %></p> <!-- Displaying the fine message -->
        <p>You will be redirected back to the requests page in a few seconds.</p>
    </div>

</body>
</html>
