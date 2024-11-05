<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Book</title>
    <style>
        .error { color: red; font-size: 0.9em; }
    </style>
</head>
<body>
    <h2>Add Book</h2>
    <form action="../auth/add_book.jsp" method="post">
        <input type="hidden" name="operation" value="addBook">

        Name: <input type="text" name="name" required><br>
        <% if (request.getAttribute("nameError") != null) { %>
            <div class="error"><%= request.getAttribute("nameError") %></div>
        <% } %>

        Author: <input type="text" name="author" required><br>
        <% if (request.getAttribute("authorError") != null) { %>
            <div class="error"><%= request.getAttribute("authorError") %></div>
        <% } %>

        Publisher: <input type="text" name="publisher" required><br>
        <% if (request.getAttribute("publisherError") != null) { %>
            <div class="error"><%= request.getAttribute("publisherError") %></div>
        <% } %>

        Title: <input type="text" name="title" required><br>
        <% if (request.getAttribute("titleError") != null) { %>
            <div class="error"><%= request.getAttribute("titleError") %></div>
        <% } %>

        Category ID: <input type="number" name="category_id" required><br>
        <% if (request.getAttribute("categoryError") != null) { %>
            <div class="error"><%= request.getAttribute("categoryError") %></div>
        <% } %>

        <input type="submit" value="Add Book">
    </form>
</body>
</html>
