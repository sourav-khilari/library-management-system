<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Library User Registration</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap');

        body {
            font-family: 'Poppins', sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            background-image: url('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: repeating-linear-gradient(45deg, rgba(248, 250, 252, 0.7), rgba(248, 250, 252, 0.7) 10px, rgba(241, 245, 249, 0.7) 10px, rgba(241, 245, 249, 0.7) 20px);
            z-index: 1;
        }



        .container {
            background-color: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
            max-width: 480px;
            width: 100%;
            position: relative;
            z-index: 2;
        }

        h2 {
            text-align: center;
            color: #0369a1;
            margin-bottom: 30px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 24px;
        }

        label {
            display: block;
            font-weight: 500;
            color: #475569;
            margin-bottom: 8px;
        }

        input[type="text"],
        input[type="password"],
        input[type="date"],
        select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-family: 'Poppins', sans-serif;
            font-size: 14px;
            color: #334155;
            background-color: #f1f5f9;
            transition: border-color 0.3s;
        }

        input[type="text"]:focus,
        input[type="password"]:focus,
        input[type="date"]:focus,
        select:focus {
            outline: none;
            border-color: #0369a1;
        }

        button {
            background-color: #0369a1;
            color: white;
            padding: 12px 16px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            width: 100%;
            font-family: 'Poppins', sans-serif;
            font-size: 16px;
            font-weight: 500;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #064e3b;
        }

        .error-message,
        .success-message {
            text-align: center;
            margin-top: 20px;
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 14px;
        }

        .error-message {
            background-color: #fce7f3;
            color: #be123c;
        }

        .success-message {
            background-color: #d1fae5;
            color: #065f46;
        }
    </style>
</head>
<body>
    <div class="overlay"></div>
    <div class="container">
        <h2>Library User Registration</h2>
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
        <div class="error-message">
            <%= request.getAttribute("errorMessage") %>
        </div>
        <% } %>

        <% if (request.getAttribute("successMessage") != null) { %>
        <div class="success-message">
            <%= request.getAttribute("successMessage") %>
        </div>
        <% } %>
    </div>

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