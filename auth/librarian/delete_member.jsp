<%@ page import="java.sql.*" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Ensure only librarians can access this page
    String role = (String) session.getAttribute("role");
    if (!"librarian".equals(role)) {
        response.sendRedirect("../login_p.jsp");
        return;
    }

    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
    String dbUsername = "SYSTEM";
    String dbPassword = "skoracle";

    // Get user ID from the request
    String userId = request.getParameter("user_id");

    if (userId != null && !userId.isEmpty()) {
        // SQL to set the user as inactive
        String deactivateUserSQL = "UPDATE Users SET status = 'inactive' WHERE user_id = ?";
        
        // SQL to reset the user's password
        String resetPasswordSQL = "UPDATE Users SET password = ? WHERE user_id = ?";
        //String newPassword = "default_password"; // Set a default password for the user

        SecureRandom random = new SecureRandom();
        StringBuilder newPassword = new StringBuilder(8);
        for (int i = 0; i < 8; i++) {
            newPassword.append(random.nextInt(10)); // Append random digit between 0 and 9
        }

        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword)) {

            // Set user status to inactive
            try (PreparedStatement pstmtDeactivate = conn.prepareStatement(deactivateUserSQL)) {
                pstmtDeactivate.setString(1, userId);
                int rowsAffected = pstmtDeactivate.executeUpdate();
                
                if (rowsAffected > 0) {
                    out.println("<p>User deactivated successfully. User ID: " + userId + "</p>");
                } else {
                    out.println("<p>Error: User account could not be found or updated.</p>");
                }
            }

            // Reset the user's password
            try (PreparedStatement pstmtResetPassword = conn.prepareStatement(resetPasswordSQL)) {
                pstmtResetPassword.setString(1, newPassword.toString());
                pstmtResetPassword.setString(2, userId);
                int passwordReset = pstmtResetPassword.executeUpdate();

                if (passwordReset > 0) {
                    out.println("<p>Password reset successfully for User ID: " + userId + "</p>");
                } else {
                    out.println("<p>Error: Password could not be updated.</p>");
                }
            }

        } catch (SQLException e) {
            out.println("Error updating user: " + e.getMessage());
        }
    } else {
        out.println("<p>Error: Invalid user ID.</p>");
    }

    // Link back to delete_member.jsp or any other page to manage users
%>
<a href="../../auth/librarian/delete_member.jsp">Back to User Management</a>
