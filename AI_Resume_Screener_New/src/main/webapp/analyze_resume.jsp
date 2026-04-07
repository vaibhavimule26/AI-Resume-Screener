<%
    String email = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("userRole");

    if (email == null || !"CANDIDATE".equals(role)) {
        response.sendRedirect("login.html");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Analyze Resume</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

<div class="dashboard-container">
    <h2>📊 Analyze Resume</h2>

    <form action="ResumeAnalysisServlet" method="post">

        <label>Paste Job Description:</label><br><br>
        <textarea name="jobDescription" rows="10" cols="80" required></textarea>

        <br><br>
        <button type="submit" class="btn">Analyze</button>
    </form>

    <br>
    <a href="candidate_dashboard.jsp" class="btn">Back</a>
</div>

</body>
</html>