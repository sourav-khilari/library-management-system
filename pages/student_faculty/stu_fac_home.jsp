<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Member Home</title>
    <style>
        /* Simple styling for the page */
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            position: relative; /* Added to position logout button */
        }
        .container {
            text-align: center;
        }
        .button {
            display: inline-block;
            padding: 15px 30px;
            margin: 20px;
            font-size: 18px;
            color: #fff;
            background-color: #4CAF50;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s ease;
        }
        .button:hover {
            background-color: #45a049;
        }

        /* Circular button in the top right corner */
        .circle-button {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #3e7e40;
            color: white;
            font-size: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            transition: background-color 0.3s;
        }

        .circle-button:hover {
            background-color: #45a049;
        }

        /* Logout button */
        .logout-button {
            position: absolute;
            top: 20px;
            left: 20px;
            background-color: #f44336;
            padding: 10px 20px;
            color: white;
            font-size: 16px;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .logout-button:hover {
            background-color: #e53935;
        }
    </style>
</head>
<body>
    <div class="logout-button">
        <a href="../logout.jsp" style="color: white; text-decoration: none;">Logout</a>
    </div>
    
    <div class="container">
        <h1>Welcome to the Library</h1>
        <p>Select an option below:</p>
        
        <!-- Button to navigate to Search and Issue Book page -->
        <a href="../search.jsp" class="button">Search & Issue Book</a>
        
        <!-- Button to navigate to Return and Pay Payment page -->
        <a href="return_payment.jsp" class="button">Return & clear fine</a>
    </div>

    <!-- Circle Button for User Details -->
    <div class="circle-button" onclick="window.location.href='../user_details.jsp';">
        <i class="fas fa-user"></i>
    </div>
</body>
</html>


