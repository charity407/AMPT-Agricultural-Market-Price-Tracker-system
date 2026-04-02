package com.agriprice.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.agriprice.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/login.html").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || password == null || email.isEmpty() || password.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Email and password required");
            return;
        }

        // Basic email format validation
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Invalid email format");
            return;
        }

        String sql = "SELECT user_id, full_name, role FROM users WHERE email_address = ? AND password_hash = ? AND account_status = 'ACTIVE'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password); // In production, hash the password

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                HttpSession session = req.getSession();
                session.setAttribute("userId", rs.getInt("user_id"));
                session.setAttribute("userRole", rs.getString("role"));
                session.setAttribute("userName", rs.getString("full_name"));
                resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login?error=Invalid credentials");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login?error=Login failed");
        }
    }
}
