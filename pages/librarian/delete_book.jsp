<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <h2>Delete Book</h2>
<form method="post">
    <input type="hidden" name="operation" value="deleteBook">
    Book ID: <input type="number" name="book_id" required><br>
    <input type="submit" value="Delete Book">
</form>
</body>
</html>