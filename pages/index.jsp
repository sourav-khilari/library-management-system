<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Library Management System</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  <style>
    body {
      font-family: 'Poppins', sans-serif;
      margin: 0;
      padding: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      background-image: url('https://images.unsplash.com/photo-1532012197267-da84d127e765?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
      background-size: cover;
      background-position: center;
      overflow: hidden; /* Prevents scrollbars */
    }

    .spotlight {
      position: absolute;
      width: 100%;
      height: 100%;
      top: 0;
      left: 0;
      background: radial-gradient(circle at center, rgba(255, 255, 255, 0.8) 0%, rgba(255, 255, 255, 0) 70%);
      z-index: 1; /* Below the container but above the body */
    }

    .container {
      background-color: rgba(255, 255, 255, 0.95); /* Slightly transparent white */
      padding: 40px;
      border-radius: 16px;
      box-shadow: 0 8px 32px rgba(31, 38, 135, 0.37);
      max-width: 800px;
      width: 100%;
      position: relative;
      z-index: 2;
      display: none; /* Hidden initially */
      flex-direction: column;
      align-items: center;
      transition: opacity 0.5s ease; /* Smooth transition for visibility */
    }

    .container.active {
      display: flex; /* Show when active */
      opacity: 1; /* Fully visible */
      animation: fadeIn 1s ease; /* Fade in animation */
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }

    .book {
      width: 60px;
      height: 90px;
      background-color: #4ca1af;
      position: absolute;
      bottom: 0; /* Start from the bottom */
      left: calc(50% - 30px); /* Center horizontally */
      border-radius: 4px;
      box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3);
      animation: moveBook 2s ease forwards; /* Move animation */
    }

    @keyframes moveBook {
      0% {
        transform: translateX(-100%) rotateY(90deg); /* Start hidden to the left */
      }
      100% {
        transform: translateX(0) rotateY(0); /* End in place */
      }
    }

    h1 {
      text-align: center;
      color: #2c3e50;
      margin-bottom: 15px;
      font-weight: 700;
      font-size: 2.5rem;
      transition: color 0.3s;
    }

    h1:hover {
      color: #4ca1af; /* Change color on hover */
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

    .description {
      text-align: center;
      color: #2c3e50;
      margin-bottom: 30px;
      font-size: 1.1rem;
      line-height: 1.5;
      padding: 0 20px;
    }

    .actions {
      display: flex;
      justify-content: center;
      margin-bottom: 30px;
    }

    .actions a {
      display: flex;
      flex-direction: column;
      align-items: center;
      margin: 0 20px;
      text-decoration: none;
      color: #2c3e50;
      transition: color 0.3s;
    }

    .actions a:hover {
      color: #4ca1af;
    }

    .actions i {
      font-size: 48px;
      margin-bottom: 10px;
      transition: transform 0.3s;
    }

    .actions a:hover i {
      transform: scale(1.1); /* Scale icon on hover */
    }

    .buttons {
      display: flex;
      justify-content: center;
    }

    .buttons a {
      background-color: #4ca1af;
      color: #FFFFFF;
      padding: 12px 20px;
      border: none;
      border-radius: 12px;
      cursor: pointer;
      font-family: 'Poppins', sans-serif;
      font-size: 16px;
      font-weight: 500;
      text-decoration: none;
      margin: 0 10px;
      transition: background-color 0.3s, transform 0.3s;
    }

    .buttons a:hover {
      background-color: #2c3e50;
      transform: translateY(-2px);
      box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    }

    @media (max-width: 768px) {
      .container {
        padding: 20px;
      }

      h1 {
        font-size: 2rem; /* Responsive font size */
      }

      .description {
        font-size: 1rem; /* Responsive font size */
      }
    }
  </style>
</head>
<body>
  <div class="spotlight"></div> <!-- Spotlight effect div -->
  <div class="book"></div> <!-- Book animation div -->
  <div class="container" id="loginSignupContainer">
    <h1>Welcome to the Department Library</h1>
    <p class="description">Explore and manage your department's library resources effortlessly. Whether you're searching for the latest titles or issuing and returning books, our intuitive system makes it all simple and efficient.</p>
    <div class="actions">
      <a href="#">
        <i class="fas fa-search"></i>
        Search for Books
      </a>
      <a href="#">
        <i class="fas fa-book-open"></i>
        Issue a Book
      </a>
      <a href="#">
        <i class="fas fa-book-reader"></i>
        Return a Book
      </a>
    </div>
    <div class="buttons">
      <a href="login_p.jsp">Login</a>
      <a href="register.jsp">Sign Up</a>
    </div>
  </div>

  <script>
    // Wait for the DOM to load
    document.addEventListener("DOMContentLoaded", function() {
      const container = document.getElementById('loginSignupContainer');

      // After a short delay, show the login/signup container
      setTimeout(() => {
        container.classList.add('active');
      }, 2200); // Delay to match the book animation duration
    });
  </script>
</body>
</html>
