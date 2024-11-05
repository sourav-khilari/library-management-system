<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"],
        input[type="password"],
        input[type="date"],
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            background-color: #007BFF;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%;
        }
        button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>User Registration</h2>
    <form action="../auth/register.jsp" method="post">
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required>
        </div>
        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>
        </div>
        <div class="form-group">
            <label for="email">Email ID:</label>
            <input type="text" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="dob">Date of Birth:</label>
            <input type="date" id="dob" name="dob" required>
        </div>
        <div class="form-group">
            <label for="user_role">Role:</label>
            <select id="user_role" name="user_role" required>
                <option value="">Select Role</option>
                <option value="student">Student</option>
                <option value="faculty">Faculty</option>
                <option value="librarian">Librarian</option>
            </select>
        </div>
        <div class="form-group">
            <label for="id">ID / Roll No:</label>
            <input type="text" id="id" name="id" required>
        </div>
        <div class="form-group" id="batchContainer" style="display: none;">
            <label for="batch">Batch:</label>
            <input type="text" id="batch" name="batch">
        </div>
        <div class="form-group">
            <label for="department">Department:</label>
            <input type="text" id="department" name="department" required>
        </div>
        <button type="submit">Register</button>
    </form>
    <% if (request.getAttribute("errorMessage") != null) { %>
        <div style="color: red;">
            <%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>
    
    <% if (request.getAttribute("successMessage") != null) { %>
        <div style="color: green;">
            <%= request.getAttribute("successMessage") %>
        </div>
    <% } %>
    

<script>
    // Show batch field only for students
    document.getElementById('user_role').addEventListener('change', function() {
        var selectedRole = this.value;
        var batchContainer = document.getElementById('batchContainer');
        if (selectedRole === 'student') {
            batchContainer.style.display = 'block';
        } else {
            batchContainer.style.display = 'none';
        }
    });
</script>
</body>
</html>
