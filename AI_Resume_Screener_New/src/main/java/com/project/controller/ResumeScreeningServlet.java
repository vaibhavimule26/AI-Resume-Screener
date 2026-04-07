package com.project.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import com.project.util.DBConnection;

@WebServlet("/ScreenResume")
public class ResumeScreeningServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        response.setContentType("text/html");

        try {
            int resumeId = Integer.parseInt(request.getParameter("resumeId"));
            int jobId = Integer.parseInt(request.getParameter("jobId"));

            Connection con = DBConnection.getConnection();

            // 1️⃣ Get resume text
            PreparedStatement ps1 =
                con.prepareStatement("SELECT resume_text FROM resumes WHERE resume_id=?");
            ps1.setInt(1, resumeId);
            ResultSet rs1 = ps1.executeQuery();

            if (!rs1.next()) {
                response.getWriter().println("❌ Resume not found");
                return;
            }

            String resume = rs1.getString("resume_text").toLowerCase();

            // 2️⃣ Get job skills
            PreparedStatement ps2 =
                con.prepareStatement("SELECT required_skills FROM jobs WHERE job_id=?");
            ps2.setInt(1, jobId);
            ResultSet rs2 = ps2.executeQuery();

            if (!rs2.next()) {
                response.getWriter().println("❌ Job not found");
                return;
            }

            String[] skills = rs2.getString("required_skills").toLowerCase().split(",");

            // 3️⃣ AI matching logic
            int match = 0;
            for (String skill : skills) {
                if (resume.contains(skill.trim())) {
                    match++;
                }
            }

            double score = (match * 100.0) / skills.length;
            String status = score >= 60 ? "SELECTED" : "REJECTED";

            // 4️⃣ SAVE RESULT INTO DATABASE
            PreparedStatement ps3 =
                con.prepareStatement(
                    "INSERT INTO screening_results (resume_id, job_id, match_score, status) " +
                    "VALUES (?, ?, ?, ?)"
                );

            ps3.setInt(1, resumeId);
            ps3.setInt(2, jobId);
            ps3.setDouble(3, score);
            ps3.setString(4, status);
            ps3.executeUpdate();

            // 5️⃣ SHOW RESULT
            response.getWriter().println("<h3>Match Score: " + score + "%</h3>");
            response.getWriter().println("<h3>Status: " + status + "</h3>");
            response.getWriter().println("<p>Result saved successfully ✅</p>");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error during AI screening");
        }
    }
}
