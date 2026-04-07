<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>

<%
    String email = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("userRole");

    if (email == null || !"ADMIN".equals(role)) {
        response.sendRedirect("login.html");
        return;
    }

    String message = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String title = request.getParameter("job_title");
        String skills = request.getParameter("required_skills");

        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO jobs (job_title, required_skills) VALUES (?, ?)"
            );
            ps.setString(1, title);
            ps.setString(2, skills);
            ps.executeUpdate();
            con.close();

            message = "Job Added Successfully ✅";

        } catch (Exception e) {
            message = "Error adding job ❌";
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Job</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">
</head>

<body>

<div class="admin-navbar">
    <div class="logo">Add Job</div>
    <a href="admin_dashboard.jsp" class="logout-btn">Back</a>
</div>

<div class="admin-container">

    <h2>Create New Job</h2>

    <form method="post">

        <input type="text" name="job_title"
               placeholder="Job Title"
               required
               style="padding:10px;width:300px;margin-bottom:15px;"><br>

        <textarea name="required_skills"
                  placeholder="Required Skills (comma separated)"
                  required
                  style="padding:10px;width:300px;height:100px;"></textarea><br><br>

        <button type="submit" class="manage-btn">
            Add Job
        </button>

    </form>

    <br>
    <p><%= message %></p>

</div>

</body>
</html>