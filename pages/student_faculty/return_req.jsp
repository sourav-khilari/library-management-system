<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Return Book Request</title>
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
            String issueId = request.getParameter("issueId");
            String userId = (String) session.getAttribute("userId");

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                // Set up database connection
                String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
                String dbUsername = "SYSTEM";
                String dbPassword = "skoracle";
                conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

                // Insert the return request in the "Return Requests" table for librarian approval
                String query = "INSERT INTO RETURN_REQUESTS (REQUEST_ID, ISSUE_ID, USER_ID, STATUS) VALUES (RETURN_REQUEST_SEQ.NEXTVAL, ?, ?, 'Pending')";
                pstmt = conn.prepareStatement(query);
                pstmt.setString(1, issueId);
                pstmt.setString(2, userId);
                pstmt.executeUpdate();

                out.println("<div class='message success'>Your request for book return has been sent to the librarian for approval.</div>");

            } catch (SQLException e) {
                out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>
    </div>
</body>
</html>
