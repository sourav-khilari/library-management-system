





<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Librarian Home</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha384-k6RqeWeci5ZR/Lv4MR0sA0FfDOMGgZ5nqPfM5IC7O0uXZ0nqB4b48t4AN/U13hku" crossorigin="anonymous">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-size: cover;
            backdrop-filter: blur(8px);
            position: relative;
        }

        .container {
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 10px;
            padding: 40px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.2);
            width: 90%;
            max-width: 600px;
            text-align: center;
        }

        h2 {
            color: #444;
            margin-bottom: 10px;
            font-size: 28px;
            font-weight: 600;
        }

        p {
            color: #666;
            margin-bottom: 20px;
            font-size: 16px;
        }

        .operation-link {
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 15px 0;
            padding: 15px 25px;
            color: white;
            text-decoration: none;
            border-radius: 30px;
            transition: background-color 0.3s, transform 0.3s;
            font-size: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }

        .operation-link i {
            margin-right: 10px; /* Space between icon and text */
        }

        .add-book {
            background-color: #3e7e40; /* Green for Add Book */
        }

        .search-update {
            background-color: #3e7e40;; /* Amber for Search/Update/Delete */
        }
        .accept-request {
        background-color: #ff9800; /* Amber/Orange for Issue Request */
    }
        .delete-member {
            background-color: #3e7e40; /* Red for Delete Member */
        }

        .operation-link:hover {
            transform: translateY(-2px);
        }

        .operation-link:active {
            transform: translateY(1px);
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

        @media (max-width: 600px) {
            h2 {
                font-size: 24px;
            }

            p {
                font-size: 14px;
            }

            .operation-link {
                padding: 10px 20px;
                font-size: 14px;
            }
        }
    </style>
</head>
<body>

    <!-- Logout button -->
    <div class="logout-button">
        <a href="../logout.jsp" style="color: white; text-decoration: none;">Logout</a>
    </div>

    <div class="container">
        <h2>Welcome, Librarian!</h2>
        <p>Manage your library operations efficiently. Choose an action below to get started:</p>
        
        <a href="add_book.jsp" class="operation-link add-book">
            <i class="fas fa-book-plus"></i> Add New Book
        </a>
        <a href="../search.jsp" class="operation-link search-update">
            <i class="fas fa-search"></i> Search/Update Book Details
        </a>
        <a href="accept_request.jsp" class="operation-link accept-request">
            <i class="fas fa-book-open"></i> Accept Book Issue Request
        </a>
        <a href="delete_member.jsp" class="operation-link delete-member">
            <i class="fas fa-user-minus"></i> Delete Member Account
        </a>
        <a href="fine_req.jsp" class="operation-link delete-member">
            <i class="fas fa-user-slash"></i>fine request
        </a>
        <a href="return_book_req.jsp" class="operation-link delete-member">
            <i class="fas fa-user-slash"></i> return request
        </a>
        <a href="accept_request.jsp" class="operation-link delete-member">
            <i class="fas fa-user-slash"></i> issue request
        </a>
        <a href="report_generation.jsp" class="operation-link delete-member">
            <i class="fas fa-user-slash"></i> report geneartion
        </a>
    </div>

    <!-- Circle Button for User Details -->
    <div class="circle-button" onclick="window.location.href='../user_details.jsp';">
        <i class="fas fa-user"></i>
    </div>
</body>
</html>
