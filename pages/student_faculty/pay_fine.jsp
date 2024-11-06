<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<% 
    String message = "";
    if (request.getMethod().equalsIgnoreCase("POST")) {
        String issueId = request.getParameter("issueId");

        // Assuming you have a session attribute for the user ID
        String userId = (String) session.getAttribute("userId");

        // Update the fine status to "Pending" in the database
        try (Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@//localhost:1521/XEPDB1", "SYSTEM", "skoracle");
             PreparedStatement pstmt = conn.prepareStatement("UPDATE ISSUED_BOOKS SET FINE_STATUS = 'Pending' WHERE ISSUE_ID = ? AND USER_ID = ?")) {

            pstmt.setString(1, issueId);
            pstmt.setString(2, userId);
            int rowsUpdated = pstmt.executeUpdate();

            if (rowsUpdated > 0) {
                message = "Fine payment request submitted.";
            } else {
                message = "Error submitting the request. Please try again.";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database error.";
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Pay Fine</title>
</head>
<body>
    <h1>Pay Fine</h1>
    <p><%= message %></p>

    <!-- Form to request fine payment -->
    <form method="post">
        <input type="hidden" name="issueId" value="<%= request.getParameter("issueId") %>">
        <button type="submit">Submit Fine Payment Request</button>
    </form>
</body>
</html>
