<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>

<%
    // Check if the request method is POST
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Database connection details
        String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"; // Using service name
        String dbUsername = "SYSTEM"; // Oracle DB username
        String dbPassword = "skoracle"; // Oracle DB password

        // Get form parameters
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String phoneNo = request.getParameter("phone_no");
        String dob = request.getParameter("dob");
        String distinction = request.getParameter("distinction");
        String userId = request.getParameter("id");
        String joinDate = request.getParameter("join_date");

        // Validate inputs
        boolean isValid = true;
        StringBuilder errorMessage = new StringBuilder();

        // Check for null or empty fields
        if (email == null || email.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Email cannot be empty.<br>");
        }
        if (username == null || username.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Username cannot be empty.<br>");
        }
        if (password == null || password.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Password cannot be empty.<br>");
        }
        if (phoneNo == null || phoneNo.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Phone number cannot be empty.<br>");
        }
        if (dob == null || dob.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Date of birth cannot be empty.<br>");
        }
        if (userId == null || userId.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("User ID cannot be empty.<br>");
        }
        if (joinDate == null || joinDate.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Join date cannot be empty.<br>");
        }

        // Check for valid email format
        String emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        if (!Pattern.matches(emailPattern, email)) {
            isValid = false;
            errorMessage.append("Invalid email format.<br>");
        }

        // Check phone number length
        if (phoneNo.length() != 10) {
            isValid = false;
            errorMessage.append("Phone number must be 10 digits long.<br>");
        }

        // Check password length
        if (password.length() < 8) {
            isValid = false;
            errorMessage.append("Password must be at least 8 characters long.<br>");
        }

        // If any validation fails, display errors
        if (!isValid) {
            out.println("<p>Registration failed due to the following errors:</p>");
            out.println("<p>" + errorMessage.toString() + "</p>");
            out.println("<p><a href='../pages/register.jsp'>Go back to registration form</a></p>");
            return; // Stop further processing
        }

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
            
            // Establish a connection
            conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
            
            // Insert SQL statement
            String sql = "INSERT INTO users_lib (email, username, password, phone_no, DOB, distinction, id, join_date) " +
                         "VALUES (?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, TO_DATE(?, 'YYYY-MM-DD'))";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, username);
            pstmt.setString(3, password);
            pstmt.setString(4, phoneNo);
            pstmt.setString(5, dob);
            pstmt.setString(6, distinction);
            pstmt.setString(7, userId);
            pstmt.setString(8, joinDate);

            // Execute the insert
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<p>Registration successful! You can now <a href='../pages/login_p.jsp'>login</a>.</p>");
            } else {
                out.println("<p>Registration failed. Please try again.</p>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<p>Error: " + e.getMessage() + "</p>");
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<p>An error occurred: " + e.getMessage() + "</p>");
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                out.println("<p>Error closing resources: " + ex.getMessage() + "</p>");
            }
        }
    } else {
        out.println("<p>Invalid request method. Please use the registration form.</p>");
    }
%>
