<%@ page import="java.sql.*, java.util.*, com.project.util.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload & Analyze Resume</title>
    <link rel="stylesheet" href="css/resume.css">
</head>
<body>

<div class="container">

    <h2>Upload Resume & Analyze</h2>

    <!-- FORM SECTION -->
    <form action="ResumeUploadServlet" method="post" enctype="multipart/form-data">

        <label>Select Resume (PDF):</label>
        <input type="file" name="resumeFile" accept=".pdf" required>

        <label>Select Job:</label>
        <select name="jobId" required>
            <option value="">-- Select Job --</option>

            <%
                try {
                    Connection con = DBConnection.getConnection();
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery("SELECT job_id, job_title FROM jobs");

                    while(rs.next()) {
            %>
                <option value="<%= rs.getInt("job_id") %>">
                    <%= rs.getString("job_title") %>
                </option>
            <%
                    }
                    con.close();
                } catch(Exception e) {
                    out.println("<option>Error loading jobs</option>");
                }
            %>
        </select>

        <button type="submit">Upload & Analyze</button>

    </form>

    <!-- RESULT SECTION -->

    <%
        Integer score = (Integer) request.getAttribute("score");

        if(score != null){

            List<String> matchedSkills =
                (List<String>) request.getAttribute("matchedSkills");

            List<String> missingSkills =
                (List<String>) request.getAttribute("missingSkills");

            List<String> suggestions =
                (List<String>) request.getAttribute("suggestions");
    %>

    <div class="score-box">

        <h3>Match Score: <%= score %>%</h3>

        <!-- Progress Bar -->
        <div class="progress-bar">
            <div class="progress-fill" style="width:<%= score %>%;">
                <%= score %>%
            </div>
        </div>

        <!-- Matched Skills -->
        <h4>✅ Matched Skills:</h4>
        <ul>
        <%
            if(matchedSkills != null){
                for(String skill : matchedSkills){
        %>
            <li class="matched"><%= skill %></li>
        <%
                }
            }
        %>
        </ul>

        <!-- Missing Skills -->
        <h4>❌ Missing Skills:</h4>
        <ul>
        <%
            if(missingSkills != null){
                for(String skill : missingSkills){
        %>
            <li class="missing"><%= skill %></li>
        <%
                }
            }
        %>
        </ul>

        <!-- Suggestions -->
        <h4>💡 Improvement Suggestions:</h4>
        <ul>
        <%
            if(suggestions != null){
                for(String suggestion : suggestions){
        %>
            <li><%= suggestion %></li>
        <%
                }
            }
        %>
        </ul>

    </div>

    <%
        }
    %>

</div>

</body>
</html>