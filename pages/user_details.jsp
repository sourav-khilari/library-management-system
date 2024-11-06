<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Details</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f9f9f9;
        }
        .container {
            background-color: #fff;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            width: 80%;
            max-width: 600px;
            text-align: center;
        }
        .user-detail {
            margin-bottom: 20px;
            font-size: 18px;
        }
        .edit-button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>User Details</h2>
        <!-- Example user details (replace with dynamic data from backend) -->
        <div class="user-detail">
            <strong>Username:</strong> john_doe
        </div>
        <div class="user-detail">
            <strong>Email:</strong> johndoe@example.com
        </div>
        <div class="user-detail">
            <strong>Role:</strong> Student
        </div>
        
        <!-- Edit button to make details editable -->
        <a href="edit_details.jsp" class="edit-button">Edit Details</a>
    </div>
</body>
</html>
