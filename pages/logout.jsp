<%
    // Invalidate the session to log the user out
    session.invalidate();
    response.sendRedirect("../pages/login_p.jsp"); // Redirect to login page after logout
%>
