<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User Details</title>
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
        h2 {
            margin-bottom: 30px;
            font-size: 24px;
        }
        .input-group {
            margin-bottom: 20px;
            text-align: left;
        }
        label {
            font-size: 16px;
            margin-bottom: 5px;
            display: block;
        }
        input[type="text"], input[type="email"], input[type="password"] {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border-radius: 5px;
            border: 1px solid #ccc;
            margin-top: 5px;
        }
        .submit-button {
            background-color: #4CAF50;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 20px;
            transition: background-color 0.3s;
        }
        .submit-button:hover {
            background-color: #45a049;
        }
        .cancel-button {
            background-color: #f44336;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        .cancel-button:hover {
            background-color: #e53935;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Edit Your Details</h2>
        <!-- Form to edit user details -->
        <form action="update_user_details.jsp" method="POST">
            <!-- Pre-fill current user data (you need to dynamically load this from your database) -->
            <div class="input-group">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" value="john_doe" readonly />
            </div>
            <div class="input-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="johndoe@example.com" required />
            </div>
            <div class="input-group">
                <label for="password">New Password:</label>
                <input type="password" id="password" name="password" placeholder="Enter new password" />
            </div>
            <div class="input-group">
                <label for="role">Role:</label>
                <input type="text" id="role" name="role" value="Student" readonly />
            </div>
            <button type="submit" class="submit-button">Update Details</button>
        </form>
        <form action="user_details.jsp" method="GET">
            <button type="submit" class="cancel-button">Cancel</button>
        </form>
    </div>
</body>
</html>
