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
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to the Library</h1>
        <p>Select an option below:</p>
        
        <!-- Button to navigate to Search and Issue Book page -->
        <a href="../search.jsp" class="button">Search & Issue Book</a>
        
        <!-- Button to navigate to Return and Pay Payment page -->
        <a href="return_payment.jsp" class="button">Return & clear fine</a>
    </div>
</body>
</html>
