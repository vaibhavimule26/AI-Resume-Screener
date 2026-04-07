<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>

<%
    String email = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("userRole");

    if (email == null || !"ADMIN".equals(role)) {
        response.sendRedirect("login.html");
        return;
    }

    Connection con = DBConnection.getConnection();
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE role='CANDIDATE'");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Candidates</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>

<body>

<div class="admin-navbar">
    <div class="logo">Candidates</div>
    <a href="admin_dashboard.jsp" class="logout-btn">Back</a>
</div>

<div class="admin-container">

    <h2>All Registered Candidates</h2>

    <table border="1" cellpadding="10" width="100%" style="background:#1e293b;color:white;">
        <tr>
            <th>ID</th>
            <th>Email</th>
        </tr>

        <%
            while (rs.next()) {
        %>

        <tr>
            <td><%= rs.getInt("user_id") %></td>
            <td><%= rs.getString("email") %></td>
        </tr>

        <%
            }
            con.close();
        %>

    </table>

</div>

</body>
</html>