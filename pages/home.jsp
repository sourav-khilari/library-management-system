<%@ page import="java.io.*" %>

<%
    String username = request.getParameter("username");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
</head>
<body>
    <h1>Welcome, <%= username != null ? username : "Guest" %>!</h1>
    <p>This is your personalized welcome page.</p>
    <!-- Add more content here -->
</body>
</html>
