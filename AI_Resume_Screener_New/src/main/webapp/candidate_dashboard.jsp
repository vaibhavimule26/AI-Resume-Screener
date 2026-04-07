<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, com.project.util.DBConnection" %>

<%
    request.setCharacterEncoding("UTF-8");

    String email = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("userRole");

    if (email == null || !"CANDIDATE".equals(role)) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Candidate Dashboard</title>

<link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css?v=5">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

</head>

<body>

<!-- ================= NAVBAR ================= -->
<div class="navbar">
    <div class="logo">AI Resume Screener</div>

    <div>
        <span class="user-email"><%= email %></span>
        <a href="LogoutServlet" class="logout-btn">Logout</a>
    </div>
</div>

<!-- ================= MAIN ================= -->
<div class="dashboard-container">

    <h2>Welcome Back 👋</h2>
    <p>Upload your resume and check job compatibility instantly.</p>

    <!-- ================= CARDS ================= -->
    <div class="card-container">

        <div class="card">
            <h3>Upload Resume</h3>
            <p>Upload your resume PDF and analyze job matching score.</p>
            <a href="upload_resume.jsp" class="btn">Upload & Analyze</a>
        </div>

        <div class="card">
            <h3>Analysis History</h3>
            <p>Track your previous job compatibility results.</p>
            <a href="#history" class="btn">View History</a>
        </div>

    </div>

    <!-- ================= HISTORY ================= -->
    <h2 id="history">📊 My Analysis History</h2>

    <table>
        <thead>
            <tr>
                <th>Job Title</th>
                <th>Match Score</th>
                <th>Date</th>
            </tr>
        </thead>
        <tbody>

        <%
            try {
                Connection con = DBConnection.getConnection();

                PreparedStatement ps = con.prepareStatement(
                    "SELECT j.job_title, a.score, a.analysis_date " +
                    "FROM analysis_history a " +
                    "JOIN jobs j ON a.job_id = j.job_id " +
                    "JOIN users u ON a.user_id = u.user_id " +
                    "WHERE u.email = ? " +
                    "ORDER BY a.analysis_date DESC"
                );

                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                while (rs.next()) {

                    int score = rs.getInt("score");
        %>

            <tr>
                <td><%= rs.getString("job_title") %></td>

                <td>
                    <div class="progress-container">
                        <div class="progress-bar"
                             style="width:<%= score %>%;
                             background:<%= score>=70 ? "#28a745" : (score>=50 ? "#ffc107" : "#dc3545") %>;">
                        </div>
                    </div>
                    <small><%= score %> %</small>
                </td>

                <td><%= rs.getTimestamp("analysis_date") %></td>
            </tr>

        <%
                }

                con.close();
            } catch (Exception e) {
        %>

            <tr>
                <td colspan="3">Error loading analysis history.</td>
            </tr>

        <%
            }
        %>

        </tbody>
    </table>

</div>

</body>
</html>