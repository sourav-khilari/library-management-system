<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Operation Selection</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        h2 {
            color: #333;
        }
        .operation-link {
            display: block;
            margin: 10px 0;
            padding: 10px;
            background-color: #007BFF;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            text-align: center;
        }
        .operation-link:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<h2>Select an Operation</h2>
<a href="add_book.jsp" class="operation-link">Add Book</a>
<a href="../serach.jsp" class="operation-link">Search/Update/Delete Book</a>
<a href="manage_books.jsp?operation=deleteMember" class="operation-link">Delete Member</a>

</body>
</html>
