package com.project.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

import com.project.util.DBConnection;

@WebServlet("/ResumeAnalysisServlet")
public class ResumeAnalysisServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // 1️⃣ Get Session
            HttpSession session = request.getSession(false);

            if (session == null) {
                response.sendRedirect("login.html");
                return;
            }

            String email = (String) session.getAttribute("userEmail");

            if (email == null) {
                response.sendRedirect("login.html");
                return;
            }

            // 2️⃣ Get Job Description
            String jobDescription = request.getParameter("jobDescription");

            if (jobDescription == null || jobDescription.trim().isEmpty()) {
                response.getWriter().println("❌ Please enter Job Description.");
                return;
            }

            jobDescription = jobDescription.toLowerCase();

            // 3️⃣ Get Latest Resume Text
            Connection con = DBConnection.getConnection();

            String sql = "SELECT resume_text FROM resumes r "
                       + "JOIN users u ON r.user_id = u.user_id "
                       + "WHERE u.email=? "
                       + "ORDER BY r.resume_id DESC LIMIT 1";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                response.getWriter().println("❌ No resume found. Please upload resume first.");
                return;
            }

            String resumeText = rs.getString("resume_text");

            if (resumeText == null || resumeText.trim().isEmpty()) {
                response.getWriter().println("❌ Resume text is empty.");
                return;
            }

            resumeText = resumeText.toLowerCase();

            // 4️⃣ Convert to word sets
            Set<String> resumeWords = new HashSet<>(Arrays.asList(resumeText.split("\\W+")));
            Set<String> jobWords = new HashSet<>(Arrays.asList(jobDescription.split("\\W+")));

            int matchedCount = 0;
            List<String> matchedSkills = new ArrayList<>();
            List<String> missingSkills = new ArrayList<>();

            for (String word : jobWords) {

                if (word.length() > 2) { // ignore very small words

                    if (resumeWords.contains(word)) {
                        matchedCount++;
                        matchedSkills.add(word);
                    } else {
                        missingSkills.add(word);
                    }
                }
            }

            int totalRelevantWords = matchedSkills.size() + missingSkills.size();
            int matchPercentage = 0;

            if (totalRelevantWords > 0) {
                matchPercentage = (int) (((double) matchedCount / totalRelevantWords) * 100);
            }

            // 5️⃣ Send Data to Result Page
            request.setAttribute("score", matchPercentage);
            request.setAttribute("matchedSkills", matchedSkills);
            request.setAttribute("missingSkills", missingSkills);

            request.getRequestDispatcher("analysis_result.jsp")
                   .forward(request, response);

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error during analysis. Check console.");
        }
    }
}