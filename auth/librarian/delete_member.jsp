<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Check if user is a librarian
    String role = (String) session.getAttribute("role");
    if (!"librarian".equals(role)) {
        response.sendRedirect("../login_p.jsp");  // Redirect if user is not a librarian
        return;
    }

    // Database connection details
    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/xe";
    String dbUsername = "system";
    String dbPassword = "root";

    // Get the user_id from the request
    String userId = request.getParameter("user_id");
    String message = "";
    boolean isSuccess = false;

    if (userId != null && !userId.isEmpty()) {
        try (Connection conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword)) {
            // Corrected query: Update status column name as per your database (status instead of user_status)
            String deactivateQuery = "UPDATE Users SET status = 'inactive' WHERE user_id = ?";  // Ensure correct column name
            try (PreparedStatement pstmt = conn.prepareStatement(deactivateQuery)) {
                pstmt.setString(1, userId);
                int rowsAffected = pstmt.executeUpdate();
                if (rowsAffected > 0) {
                    isSuccess = true;
                    message = "User deactivated successfully. User ID: " + userId;
                    
                    // Reset password for the user (generating a new random password)
                    String resetPasswordQuery = "UPDATE Users SET password = 'new_random_password' WHERE user_id = ?";
                    try (PreparedStatement resetPstmt = conn.prepareStatement(resetPasswordQuery)) {
                        resetPstmt.setString(1, userId);
                        resetPstmt.executeUpdate();
                        message += "<br>Password reset successfully for User ID: " + userId;
                    }
                } else {
                    message = "Error: User ID not found!";
                }
            }
        } catch (SQLException e) {
            message = "Error: " + e.getMessage();
        }
    }

    // If the deletion was successful, display success message and auto-redirect
    if (isSuccess) {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="5;url=../pages/user_management.jsp"> <!-- Auto redirect after 5 seconds -->
    <title>User Deactivated</title>
    <link rel="stylesheet" type="text/css" href="delete_member.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        
        .container {
            background-color: white;
            padding: 30px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            border-radius: 8px;
            width: 80%;
            max-width: 600px;
        }

        h2 {
            color: #27ae60;
        }

        p {
            color: #555;
            font-size: 16px;
            margin: 20px 0;
        }

        a {
            color: #3498db;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>User Deactivated Successfully</h2>
        <p><%= message %></p>
        <p>You will be redirected to the User Management page in 5 seconds. If not, <a href="../../pages/librarian/librarian_home.jsp">click here</a> to go manually.</p>
    </div>
</body>
</html>
<%
    } else {
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="5;url=../../pages/librarian/librarian_home.jsp"> <!-- Auto redirect after 5 seconds -->
    <title>Error</title>
    <link rel="stylesheet" type="text/css" href="delete_member.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        
        .container {
            background-color: white;
            padding: 30px;
            box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
            border-radius: 8px;
            width: 80%;
            max-width: 600px;
        }

        h2 {
            color: #e74c3c;
        }

        p {
            color: #555;
            font-size: 16px;
            margin: 20px 0;
        }

        a {
            color: #3498db;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Error</h2>
        <p><%= message %></p>
        <p>You will be redirected to the User Management page in 5 seconds. If not, <a href="../../pages/librarian/librarian_home.jsp">click here</a> to go manually.</p>
    </div>
</body>
</html>
<%
    }
%>
