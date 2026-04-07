<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>

<%
    request.setCharacterEncoding("UTF-8");

    String email = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("userRole");

    if (email == null || !"ADMIN".equals(role)) {
        response.sendRedirect("login.html");
        return;
    }

    int totalJobs = 0;
    int totalCandidates = 0;
    int totalResumes = 0;
    int totalScreenings = 0;

    try {
        Connection con = DBConnection.getConnection();

        Statement stmt = con.createStatement();

        ResultSet rs1 = stmt.executeQuery("SELECT COUNT(*) FROM jobs");
        if (rs1.next()) totalJobs = rs1.getInt(1);

        ResultSet rs2 = stmt.executeQuery("SELECT COUNT(*) FROM users WHERE role='CANDIDATE'");
        if (rs2.next()) totalCandidates = rs2.getInt(1);

        ResultSet rs3 = stmt.executeQuery("SELECT COUNT(*) FROM resumes");
        if (rs3.next()) totalResumes = rs3.getInt(1);

        ResultSet rs4 = stmt.executeQuery("SELECT COUNT(*) FROM analysis_history");
        if (rs4.next()) totalScreenings = rs4.getInt(1);

        con.close();

    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Dashboard</title>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css?v=1">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

</head>

<body>

<!-- Navbar -->
<div class="admin-navbar">
    <div class="logo">AI Resume Screener - Admin</div>
    <div>
        <span><%= email %></span>
        <a href="LogoutServlet" class="logout-btn">Logout</a>
    </div>
</div>

<div class="admin-container">

    <h2>Admin Control Panel 📊</h2>

    <!-- Statistics Cards -->
    <div class="stats-container">

        <div class="stat-card">
            <h3><%= totalJobs %></h3>
            <p>Total Jobs</p>
        </div>

        <div class="stat-card">
            <h3><%= totalCandidates %></h3>
            <p>Total Candidates</p>
        </div>

        <div class="stat-card">
            <h3><%= totalResumes %></h3>
            <p>Total Resumes</p>
        </div>

        <div class="stat-card">
            <h3><%= totalScreenings %></h3>
            <p>Total Screenings</p>
        </div>

    </div>

    <!-- Management Section -->
    <div class="management-container">

        <a href="admin_add_job.jsp" class="manage-btn">Add Job</a>
        <a href="admin_view_jobs.jsp" class="manage-btn">View Jobs</a>
        <a href="admin_view_candidates.jsp" class="manage-btn">View Candidates</a>
        <a href="admin_view_resumes.jsp" class="manage-btn">View Resumes</a>
        <a href="admin_screening_results.jsp" class="manage-btn">Screening Results</a>

    </div>

</div>

</body>
</html>