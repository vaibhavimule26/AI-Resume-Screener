<%
    String role = (String) session.getAttribute("userRole");
    if (!"ADMIN".equals(role)) {
        response.sendRedirect("login.html");
        return;
    }
%>

<h2>Add Job</h2>

<form action="JobServlet" method="post">
    Job Title:<br>
    <input type="text" name="title" required><br><br>

    Required Skills (comma separated):<br>
    <textarea name="skills" rows="5" cols="50" required></textarea><br><br>

    <button type="submit">Add Job</button>
</form>
