package com.project.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;

import com.project.util.DBConnection;

@WebServlet("/TestServlet")
public class TestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        Connection con = DBConnection.getConnection();

        response.getWriter().println("<html>");
        response.getWriter().println("<body>");

        if (con != null) {
            response.getWriter().println("<h1>Backend + Database working ✅</h1>");
        } else {
            response.getWriter().println("<h1>Database connection failed ❌</h1>");
        }

        response.getWriter().println("</body>");
        response.getWriter().println("</html>");
    }
}
