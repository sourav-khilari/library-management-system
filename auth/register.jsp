<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.*" %>
<%@ page import="java.util.UUID" %>
<%@ page import="java.math.BigInteger" %>

<%
    // Check if the request method is POST
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        // Database connection details
        String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"; // Using service name
        String dbUsername = "SYSTEM";                                  // Oracle DB username
        String dbPassword = "skoracle"; 

        // Get form parameters
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String dob = request.getParameter("dob");
        String userRole = request.getParameter("user_role");
        String department = request.getParameter("department"); // Capture the department

        // Generate a unique user ID of fixed length 10
        String uuid = UUID.randomUUID().toString().replace("-", ""); // Remove dashes
        BigInteger bigInt = new BigInteger(uuid, 16); // Convert to BigInteger
        String userId = bigInt.toString(36); // Convert to base-36 string
        userId = userId.substring(0, Math.min(userId.length(), 10)); // Limit to 10 characters

        String batch = request.getParameter("batch"); // Only for students

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
        if (dob == null || dob.trim().isEmpty()) {
            isValid = false;
            errorMessage.append("Date of birth cannot be empty.<br>");
        }

        // Check for valid email format
        String emailPattern = "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$";
        if (!Pattern.matches(emailPattern, email)) {
            isValid = false;
            errorMessage.append("Invalid email format.<br>");
        }

        // If any validation fails, display errors
        if (!isValid) {
            request.setAttribute("errorMessage", errorMessage.toString());
            request.getRequestDispatcher("../pages/register.jsp").forward(request, response);
            return; // Stop further processing
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        PreparedStatement checkUserStmt = null;

        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");

            // Establish a connection
            conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

            // Check if the user already exists
            String checkUserSql = "SELECT COUNT(*) FROM Users WHERE email = ?";
            checkUserStmt = conn.prepareStatement(checkUserSql);
            checkUserStmt.setString(1, email);
            ResultSet rs = checkUserStmt.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                request.setAttribute("errorMessage", "User with this email already exists. Please use a different email.");
                request.getRequestDispatcher("../pages/register.jsp").forward(request, response);
                return; // Stop further processing
            }

            // Insert SQL statement
            String sql = "INSERT INTO Users (user_id, email, username, password, DOB, id, user_role, batch, department) " +
                         "VALUES (?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), ?, ?, ?, ?)"; // Add department to the SQL

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userId); // Set the unique user ID
            pstmt.setString(2, email);
            pstmt.setString(3, username);
            pstmt.setString(4, password);
            pstmt.setString(5, dob);
            pstmt.setString(6, request.getParameter("id")); // This is the ID field for the student or faculty
            pstmt.setString(7, userRole);
            pstmt.setString(8, batch); // Optional, could be NULL
            pstmt.setString(9, department); // Set the department value

            // Execute the insert
            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                request.setAttribute("successMessage", "Registration successful! You can now log in.");
                request.getRequestDispatcher("../pages/register.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Registration failed. Please try again.");
                request.getRequestDispatcher("../pages/register.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("../pages/register.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("../pages/register.jsp").forward(request, response);
        } finally {
            // Close resources
            try {
                if (pstmt != null) pstmt.close();
                if (checkUserStmt != null) checkUserStmt.close();
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                out.println("<p>Error closing resources: " + ex.getMessage() + "</p>");
            }
        }
    } else {
        request.setAttribute("errorMessage", "Invalid request method. Please use the registration form.");
        request.getRequestDispatcher("../pages/register.jsp").forward(request, response);
    }
%>
