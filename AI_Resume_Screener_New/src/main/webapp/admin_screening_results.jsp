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

    String sql = "SELECT u.email, j.job_title, a.score, a.analysis_date " +
                 "FROM analysis_history a " +
                 "JOIN users u ON a.user_id=u.user_id " +
                 "JOIN jobs j ON a.job_id=j.job_id";

    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery(sql);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Screening Results</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>

<body>

<div class="admin-navbar">
    <div class="logo">Screening Results</div>
    <a href="admin_dashboard.jsp" class="logout-btn">Back</a>
</div>

<div class="admin-container">

    <h2>All Screening Results</h2>

    <table border="1" cellpadding="10" width="100%" style="background:#1e293b;color:white;">
        <tr>
            <th>Candidate</th>
            <th>Job</th>
            <th>Score</th>
            <th>Date</th>
        </tr>

        <%
            while (rs.next()) {
        %>

        <tr>
            <td><%= rs.getString("email") %></td>
            <td><%= rs.getString("job_title") %></td>
            <td><%= rs.getInt("score") %> %</td>
            <td><%= rs.getTimestamp("analysis_date") %></td>
        </tr>

        <%
            }
            con.close();
        %>

    </table>

</div>

</body>
</html>