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

    String sql = "SELECT r.resume_id, u.email, r.file_name, r.upload_date " +
                 "FROM resumes r JOIN users u ON r.user_id=u.user_id";

    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery(sql);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Resumes</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>

<body>

<div class="admin-navbar">
    <div class="logo">Uploaded Resumes</div>
    <a href="admin_dashboard.jsp" class="logout-btn">Back</a>
</div>

<div class="admin-container">

    <h2>All Resumes</h2>

    <table border="1" cellpadding="10" width="100%" style="background:#1e293b;color:white;">
        <tr>
            <th>Resume ID</th>
            <th>Candidate</th>
            <th>File Name</th>
            <th>Date</th>
        </tr>

        <%
            while (rs.next()) {
        %>

        <tr>
            <td><%= rs.getInt("resume_id") %></td>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("file_name") %></td>
            <td><%= rs.getTimestamp("upload_date") %></td>
        </tr>

        <%
            }
            con.close();
        %>

    </table>

</div>

</body>
</html>