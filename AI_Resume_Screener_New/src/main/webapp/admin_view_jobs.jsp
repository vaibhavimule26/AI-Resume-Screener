<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>

<%
    String email = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("userRole");

    if (email == null || !"ADMIN".equals(role)) {
        response.sendRedirect("login.html");
        return;
    }

    try {
        Connection con = DBConnection.getConnection();

        // Delete Job if requested
        String deleteId = request.getParameter("delete");
        if (deleteId != null) {
            PreparedStatement psDel = con.prepareStatement("DELETE FROM jobs WHERE job_id=?");
            psDel.setInt(1, Integer.parseInt(deleteId));
            psDel.executeUpdate();
        }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Jobs</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>

<body>

<div class="admin-navbar">
    <div class="logo">All Jobs</div>
    <a href="admin_dashboard.jsp" class="logout-btn">Back</a>
</div>

<div class="admin-container">

    <h2>Job Listings</h2>

    <table border="1" cellpadding="10" width="100%" style="background:#1e293b;color:white;">
        <tr>
            <th>ID</th>
            <th>Job Title</th>
            <th>Required Skills</th>
            <th>Action</th>
        </tr>

<%
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM jobs");

        while (rs.next()) {
%>

        <tr>
            <td><%= rs.getInt("job_id") %></td>
            <td><%= rs.getString("job_title") %></td>
            <td><%= rs.getString("required_skills") %></td>
            <td>
                <a href="?delete=<%= rs.getInt("job_id") %>" 
                   style="color:red;">Delete</a>
            </td>
        </tr>

<%
        }

        con.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

    </table>

</div>

</body>
</html>