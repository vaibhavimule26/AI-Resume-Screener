<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Analysis Result</title>
    <link rel="stylesheet" href="css/dashboard.css">
</head>
<body>

<div class="dashboard-container">

<%
    Integer score = (Integer) request.getAttribute("score");
    List<String> matchedSkills = (List<String>) request.getAttribute("matchedSkills");
    List<String> missingSkills = (List<String>) request.getAttribute("missingSkills");
%>

    <h2>📊 Resume Analysis Result</h2>

    <h3>Match Score: 
        <%= (score != null ? score : 0) %> %
    </h3>

    <hr>

    <h3>✅ Matched Skills:</h3>
    <ul>
    <%
        if (matchedSkills != null) {
            for (String skill : matchedSkills) {
    %>
        <li><%= skill %></li>
    <%
            }
        }
    %>
    </ul>

    <h3>❌ Missing Skills:</h3>
    <ul>
    <%
        if (missingSkills != null) {
            for (String skill : missingSkills) {
    %>
        <li><%= skill %></li>
    <%
            }
        }
    %>
    </ul>

    <br>
    <a href="candidate_dashboard.jsp" class="btn">Back to Dashboard</a>

</div>

</body>
</html>