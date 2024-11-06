<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Librarian Dashboard</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .container { width: 80%; margin: auto; padding-top: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        table, th, td { border: 1px solid black; }
        th, td { padding: 10px; text-align: left; }
        .approve { background-color: #4CAF50; color: white; padding: 5px 10px; cursor: pointer; }
        .reject { background-color: #f44336; color: white; padding: 5px 10px; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Librarian Dashboard - Pending Book Return Requests</h2>
        <table>
            <tr>
                <th>Request ID</th>
                <th>User ID</th>
                <th>Issue ID</th>
                <th>Action</th>
            </tr>
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;

                try {
                    String jdbcUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1";
                    String dbUsername = "SYSTEM";
                    String dbPassword = "skoracle";
                    Class.forName("oracle.jdbc.driver.OracleDriver");
                    conn = DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);

                    String query = "SELECT * FROM RETURN_REQUESTS WHERE STATUS = 'Pending'";
                    pstmt = conn.prepareStatement(query);
                    rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String requestId = rs.getString("REQUEST_ID");
                        String issueId = rs.getString("ISSUE_ID");
                        String userId = rs.getString("USER_ID");

                        out.println("<tr>");
                        out.println("<td>" + requestId + "</td>");
                        out.println("<td>" + userId + "</td>");
                        out.println("<td>" + issueId + "</td>");
                        out.println("<td>");
                        out.println("<form action='../../auth/librarian/return_book.jsp' method='post'>");
                        out.println("<input type='hidden' name='requestId' value='" + requestId + "'>");
                        out.println("<input type='hidden' name='issueId' value='" + issueId + "'>");
                        out.println("<input type='hidden' name='userId' value='" + userId + "'>");
                        out.println("<button type='submit' name='action' value='approve' class='approve'>Approve</button>");
                        out.println("<button type='submit' name='action' value='reject' class='reject'>Reject</button>");
                        out.println("</form>");
                        out.println("</td>");
                        out.println("</tr>");
                    }

                } catch (SQLException | ClassNotFoundException e) {
                    out.println("<div class='message error'>Error: " + e.getMessage() + "</div>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
            %>
        </table>
    </div>
</body>
</html>
