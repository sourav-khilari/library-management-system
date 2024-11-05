<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Library Management System - Login</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha384-k6RqeWeci5ZR/Lv4MR0sA0FfDOMz3r0E9z0xjH3lg3Yde50aaSxktR7M2qXz5K" crossorigin="anonymous">

  <style>
    body {
      font-family: 'Poppins', sans-serif;
      margin: 0;
      padding: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      background-image: linear-gradient(to right, #2c3e50, #4ca1af);
      background-size: 200% 200%;
      animation: backgroundGradient 10s ease infinite;
    }

    @keyframes backgroundGradient {
      0% {
        background-position: 0% 50%;
      }
      50% {
        background-position: 100% 50%;
      }
      100% {
        background-position: 0% 50%;
      }
    }

    .container {
      background-color: #FFFFFF;
      padding: 40px;
      border-radius: 16px;
      box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
      max-width: 400px;
      width: 100%;
      position: relative;
      z-index: 2;
      transition: transform 0.5s, box-shadow 0.5s;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .container:hover {
      transform: translateY(-10px);
      box-shadow: 0 12px 32px 0 rgba(31, 38, 135, 0.6);
    }

    h1 {
      text-align: center;
      color: #2c3e50;
      margin-bottom: 30px;
      font-weight: 700;
      position: relative;
    }

    h1:before {
      content: "";
      position: absolute;
      bottom: -10px;
      left: 50%;
      transform: translateX(-50%);
      width: 50px;
      height: 4px;
      background-color: #4ca1af;
      border-radius: 2px;
    }

    form {
      display: flex;
      flex-direction: column;
      width: 100%;
    }

    .form-group {
      margin-bottom: 20px;
      position: relative;
    }

    .form-group i {
      position: absolute;
      top: 50%;
      transform: translateY(-50%);
      left: 16px;
      color: #2c3e50;
    }

    input[type="text"],
    input[type="password"] {
      width: 100%;
      padding: 12px 16px 12px 40px;
      border: 1px solid #dfe6e9;
      border-radius: 12px;
      font-family: 'Poppins', sans-serif;
      font-size: 14px;
      color: #2c3e50;
      background-color: #f1f2f6;
      transition: border-color 0.3s, box-shadow 0.3s;
      box-sizing: border-box;
    }

    .form-group input:focus {
      outline: none;
      border-color: #4ca1af;
      box-shadow: 0 0 8px rgba(76, 161, 175, 0.5);
    }

    button {
      background-color: #4ca1af;
      color: #FFFFFF;
      padding: 12px 16px;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      font-family: 'Poppins', sans-serif;
      font-size: 16px;
      font-weight: 500;
      transition: background-color 0.3s;
      position: relative;
      overflow: hidden;
    }

    button:before {
      content: "";
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background-color: rgba(255, 255, 255, 0.3);
      transition: left 0.3s;
    }

    button:hover {
      background-color: #2c3e50;
    }

    button:hover:before {
      left: 100%;
    }

    .error-message,
    .success-message {
      text-align: center;
      margin-top: 20px;
      padding: 12px 16px;
      border-radius: 12px;
      font-size: 14px;
    }

    .error-message {
      background-color: #f8d7da;
      color: #842029;
    }

    .success-message {
      background-color: #d1e7dd;
      color: #0f5132;
    }

    .signup-button {
      margin-top: 20px;
      background-color: #ff9800; /* Orange color */
      color: #FFFFFF;
      padding: 12px 16px;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      font-family: 'Poppins', sans-serif;
      font-size: 16px;
      font-weight: 500;
      transition: background-color 0.3s;
      position: relative;
      overflow: hidden;
      width: 100%;
    }

    .signup-button:before {
      content: "";
      position: absolute;
      top: 0;
      left: -100%;
      width: 100%;
      height: 100%;
      background-color: rgba(255, 255, 255, 0.3);
      transition: left 0.3s;
    }

    .signup-button:hover {
      background-color: #e67e22; /* Darker orange on hover */
    }

    .signup-button:hover:before {
      left: 100%;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Welcome to the Library</h1>
    <form action="../auth/login_se.jsp" method="post">
      <div class="form-group">
        <i class="fas fa-user"></i>
        <input type="text" id="email" name="email" placeholder="Email" required>
      </div>
      <div class="form-group">
        <i class="fas fa-lock"></i>
        <input type="password" id="password" name="password" placeholder="Password" required>
      </div>
      <button type="submit">Login</button>
    </form>

    <button class="signup-button" onclick="window.location.href='register.jsp'">New to the library? Sign Up!</button>

    <% String error=request.getParameter("error"); if (error !=null && error.equals("1")) { %>
    <div class="error-message">
      Invalid username or password. Please try again.
    </div>
    <% } %>

    <% String rs=request.getParameter("registration"); if (rs !=null && rs.equals("success")) { %>
    <div class="success-message">
      Your Registration is Successful. Please Login.
    </div>
    <% } %>
  </div>
</body>
</html>
