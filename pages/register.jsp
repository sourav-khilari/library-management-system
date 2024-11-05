<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Registration</title>
</head>
<body>
    <h1>User Registration</h1>

    <form action="../auth/register.jsp" method="post">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required><br><br>
        
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required><br><br>
        
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required><br><br>
        
        <label for="phone_no">Phone Number:</label>
        <input type="text" id="phone_no" name="phone_no" required><br><br>
        
        <label for="dob">Date of Birth:</label>
        <input type="date" id="dob" name="dob" required><br><br>
        
        <label for="distinction">Distinction:</label>
        <input type="text" id="distinction" name="distinction"><br><br>
        
        <label for="id">User ID:</label>
        <input type="text" id="id" name="id" required><br><br>
        
        <label for="join_date">Join Date:</label>
        <input type="date" id="join_date" name="join_date" required><br><br>

        <input type="submit" value="Register">
    </form>
</body>
</html>
