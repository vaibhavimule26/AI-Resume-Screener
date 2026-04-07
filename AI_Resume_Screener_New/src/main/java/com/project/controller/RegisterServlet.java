package com.project.controller;

import java.io.IOException;
import java.sql.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ GET ALL PARAMETERS
        String name = request.getParameter("name");   // 🔥 NEW
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/ai_resume_screener",
                    "root",
                    "Vaibhavi@1722"
            );

            // ✅ CHECK IF EMAIL ALREADY EXISTS (GOOD PRACTICE 🔥)
            PreparedStatement check = con.prepareStatement(
                    "SELECT * FROM users WHERE email=?");
            check.setString(1, email);

            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                // email already exists
                response.sendRedirect("index.jsp?msg=exists");
                return;
            }

            // ✅ INSERT WITH NAME
            PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO users(name, email, password, role) VALUES (?, ?, ?, ?)");

            ps.setString(1, name);         // 🔥 FIXED
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, "CANDIDATE");

            int i = ps.executeUpdate();

            if (i > 0) {
                response.sendRedirect("index.jsp?msg=success");
            } else {
                response.sendRedirect("index.jsp?msg=error");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("index.jsp?msg=error");
        }
    }
}