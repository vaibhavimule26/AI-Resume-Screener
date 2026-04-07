package com.project.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.project.util.DBConnection;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT email, role FROM users WHERE email=? AND password=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // ✅ LOGIN SUCCESS
                HttpSession session = request.getSession(true);
                session.setAttribute("userEmail", rs.getString("email"));
                session.setAttribute("userRole", rs.getString("role"));

                // ✅ ROLE-BASED REDIRECT
                if ("ADMIN".equals(rs.getString("role"))) {
                    response.sendRedirect(request.getContextPath() + "/admin_dashboard.jsp");
                } else {
                    response.sendRedirect(request.getContextPath() + "/candidate_dashboard.jsp");
                }

            } else {
                // ❌ INVALID LOGIN
                response.sendRedirect(request.getContextPath() + "/login.html");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.html");
        }
    }
}
