<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h2>Update Book</h2>
    <form method="post">
        <input type="hidden" name="operation" value="updateBook">
        Book ID: <input type="number" name="book_id" required><br>
        Name: <input type="text" name="name"><br>
        Author: <input type="text" name="author"><br>
        Publisher: <input type="text" name="publisher"><br>
        Title: <input type="text" name="title"><br>
        Category ID: <input type="number" name="category_id"><br>
        <input type="submit" value="Update Book">
    </form>
</body>
</html>