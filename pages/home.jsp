<%
    // Check if user is logged in by verifying session attribute
    String username = (String) session.getAttribute("username");
    if (username != null) {
%>
    <h1>Welcome, <%= username %>!</h1>
    <p>This is your home page.</p>
    <a href="logout.jsp">Logout</a>
<%
    } else {
%>
    <p>Please log in to access this page.</p>
    <a href="login_p.jsp">Go to Login</a>
<%
    }
%>
