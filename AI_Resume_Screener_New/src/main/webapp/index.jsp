<%@ page language="java" %>

<!DOCTYPE html>

<html>
<head>
    <title>AI Resume Screener</title>
    <meta charset="UTF-8">

```
<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

<!-- CSS -->
<link rel="stylesheet" href="css/style.css">
```

</head>

<body>

<div class="login-wrapper">
    <div class="login-card">

```
    <!-- TITLE -->
    <h1 class="logo-text">AI Resume Screener</h1>
    <p class="subtitle">Smart AI Powered Hiring System</p>

    <!-- ================= MESSAGE ================= -->
    <%
        String msg = request.getParameter("msg");

        if ("success".equals(msg)) {
    %>
        <p style="color: green; text-align:center; font-weight:bold;">
            Registration Successful! Please login.
        </p>
    <% 
        } else if ("error".equals(msg)) { 
    %>
        <p style="color: red; text-align:center; font-weight:bold;">
            Something went wrong. Please try again.
        </p>
    <% 
        } else if ("exists".equals(msg)) { 
    %>
        <p style="color: orange; text-align:center; font-weight:bold;">
            Email already registered!
        </p>
    <% 
        } 
    %>

    <!-- ================= LOGIN ================= -->
    <form action="LoginServlet" method="post">

        <div class="input-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="Enter your email" required>
        </div>

        <div class="input-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter your password" required>
        </div>

        <button type="submit" class="login-btn">Login</button>
    </form>

    <hr>

    <!-- ================= REGISTER ================= -->
    <h3 style="text-align:center;">Register</h3>

    <form action="RegisterServlet" method="post">

        <!-- ✅ NAME FIELD (FIXED) -->
        <div class="input-group">
            <label>Full Name</label>
            <input type="text" name="name" placeholder="Enter your full name" required>
        </div>

        <div class="input-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="Enter your email" required>
        </div>

        <div class="input-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Create password" required>
        </div>

        <button type="submit" class="login-btn">Register</button>
    </form>

</div>
```

</div>

</body>
</html>
