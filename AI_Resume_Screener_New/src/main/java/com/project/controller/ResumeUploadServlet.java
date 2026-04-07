package com.project.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.sql.*;
import java.util.*;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import com.project.util.DBConnection;

@WebServlet("/ResumeUploadServlet")
@MultipartConfig
public class ResumeUploadServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Connection con = null;

        try {

            // ===== 1️⃣ CHECK SESSION =====
            HttpSession session = request.getSession(false);

            if (session == null) {
                response.sendRedirect("login.html");
                return;
            }

            String email = (String) session.getAttribute("userEmail");

            if (email == null || email.trim().isEmpty()) {
                response.sendRedirect("login.html");
                return;
            }

            email = email.trim().toLowerCase();

            // ===== 2️⃣ HANDLE FILE UPLOAD SAFELY =====
            Part filePart = request.getPart("resumeFile");
            String fileName = filePart.getSubmittedFileName();

            if (fileName == null || !fileName.toLowerCase().endsWith(".pdf")) {
                response.getWriter().println("Only PDF files allowed.");
                return;
            }

            // SAFE UPLOAD PATH (NOT inside Tomcat folder)
            String uploadPath = System.getProperty("user.home") 
                                + File.separator 
                                + "resume_uploads";

            File uploadDir = new File(uploadPath);

            if (!uploadDir.exists()) {
                uploadDir.mkdirs();   // create folder if not exists
            }

            String filePath = uploadPath + File.separator + fileName;

            filePart.write(filePath);   // Save file safely

            // ===== 3️⃣ EXTRACT TEXT FROM PDF =====
            PDDocument document = PDDocument.load(new File(filePath));
            PDFTextStripper stripper = new PDFTextStripper();
            String resumeText = stripper.getText(document);
            document.close();

            if (resumeText == null) resumeText = "";
            resumeText = resumeText.toLowerCase();

            con = DBConnection.getConnection();

            // ===== 4️⃣ SAVE RESUME INTO DB =====
            String insertResume = "INSERT INTO resumes (user_id, resume_text, file_name) "
                    + "SELECT user_id, ?, ? FROM users WHERE LOWER(email)=?";

            PreparedStatement insertPs = con.prepareStatement(insertResume);
            insertPs.setString(1, resumeText);
            insertPs.setString(2, fileName);
            insertPs.setString(3, email);
            insertPs.executeUpdate();

            // ===== 5️⃣ GET SELECTED JOB =====
            String jobIdStr = request.getParameter("jobId");

            if (jobIdStr == null || jobIdStr.isEmpty()) {
                response.getWriter().println("Please select a job.");
                return;
            }

            int jobId = Integer.parseInt(jobIdStr);

            PreparedStatement jobPs = con.prepareStatement(
                    "SELECT required_skills FROM jobs WHERE job_id=?");
            jobPs.setInt(1, jobId);
            ResultSet jobRs = jobPs.executeQuery();

            if (!jobRs.next()) {
                response.getWriter().println("Job not found.");
                return;
            }

            String requiredSkills = jobRs.getString("required_skills");

            if (requiredSkills == null) requiredSkills = "";
            requiredSkills = requiredSkills.toLowerCase();

            // ===== 6️⃣ MATCHING LOGIC =====
            Set<String> resumeWords = new HashSet<>(Arrays.asList(resumeText.split("\\W+")));
            Set<String> jobWords = new HashSet<>(Arrays.asList(requiredSkills.split("\\W+")));

            List<String> matchedSkills = new ArrayList<>();
            List<String> missingSkills = new ArrayList<>();

            for (String word : jobWords) {
                if (word.length() > 2) {
                    if (resumeWords.contains(word)) {
                        matchedSkills.add(word);
                    } else {
                        missingSkills.add(word);
                    }
                }
            }

            int total = matchedSkills.size() + missingSkills.size();
            int score = 0;

            if (total > 0) {
                score = (int) (((double) matchedSkills.size() / total) * 100);
            }

            // ===== 7️⃣ GENERATE SUGGESTIONS =====
            List<String> suggestions = new ArrayList<>();

            for (String skill : missingSkills) {
                suggestions.add("Consider adding experience related to " + skill + ".");
            }

            // ===== 8️⃣ SAVE ANALYSIS HISTORY SAFELY =====
            PreparedStatement userPs = con.prepareStatement(
                    "SELECT user_id FROM users WHERE LOWER(email)=?");
            userPs.setString(1, email);
            ResultSet userRs = userPs.executeQuery();

            if (userRs.next()) {

                int userId = userRs.getInt("user_id");

                PreparedStatement historyPs = con.prepareStatement(
                        "INSERT INTO analysis_history (user_id, job_id, score) VALUES (?, ?, ?)");
                historyPs.setInt(1, userId);
                historyPs.setInt(2, jobId);
                historyPs.setInt(3, score);
                historyPs.executeUpdate();
            }

            // ===== 9️⃣ SEND RESULTS BACK =====
            request.setAttribute("score", score);
            request.setAttribute("matchedSkills", matchedSkills);
            request.setAttribute("missingSkills", missingSkills);
            request.setAttribute("suggestions", suggestions);

            request.getRequestDispatcher("upload_resume.jsp")
                   .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error processing resume.");
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception ignored) {}
        }
    }
}