<%@ page session="true" %>
<%
    String email = (String) session.getAttribute("userEmail");
    if (email == null) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>

<h1>Welcome to Dashboard 🎉</h1>
<p>Logged in as: <b><%= email %></b></p>

<a href="LogoutServlet">Logout</a>

</body>
</html>
