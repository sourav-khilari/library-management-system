<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>
    <form action="../auth/login_se.jsp" method="post">
        <input type="text" name="email" id="">
        <input type="text" name="password" id="">
        <input type="submit" name="" id="">
    </form>

    <% String error=request.getParameter("error");
    if (error !=null && error.equals("1")) { %>
        <p style="color: red;">Invalid username or password. Please try again.</p>
        <% } %>

    <%-- Display error message if Register Successful --%>
    <% String rs=request.getParameter("registration"); 
    if (rs !=null && rs.equals("success")) { %>
        <p style="color: green;">Your Registration is Successful. Please Login.</p>
    <% } %>
</body>

</html>