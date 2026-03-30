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

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Object userIdObj = session.getAttribute("userId");

        if (userIdObj == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        int userId = (Integer) userIdObj;

        try {
            String sql = "SELECT user_id, full_name, email_address, phone, role, account_status FROM users WHERE user_id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    req.setAttribute("userId", rs.getInt("user_id"));
                    req.setAttribute("fullName", rs.getString("full_name"));
                    req.setAttribute("email", rs.getString("email_address"));
                    req.setAttribute("phone", rs.getString("phone"));
                    req.setAttribute("role", rs.getString("role"));
                    req.setAttribute("status", rs.getString("account_status"));
                } else {
                    req.setAttribute("error", "User not found");
                }
            }

            req.getRequestDispatcher("/jsp/profile/profile.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading profile: " + e.getMessage());
            try {
                req.getRequestDispatcher("/jsp/profile/profile.jsp").forward(req, resp);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Object userIdObj = session.getAttribute("userId");

        if (userIdObj == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        int userId = (Integer) userIdObj;

        try {
            String fullName = req.getParameter("fullName");
            String phone = req.getParameter("phone");
            String email = req.getParameter("email");

            // Validate input
            if (fullName == null || fullName.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/profile?error=Full name is required");
                return;
            }

            String sql = "UPDATE users SET full_name = ?, phone = ?, email_address = ? WHERE user_id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, fullName.trim());
                ps.setString(2, phone != null ? phone.trim() : null);
                ps.setString(3, email != null ? email.trim() : null);
                ps.setInt(4, userId);

                ps.executeUpdate();

                // Update session with new name
                session.setAttribute("userName", fullName.trim());

                resp.sendRedirect(req.getContextPath() + "/profile?success=Profile updated successfully");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/profile?error=Error updating profile: " + e.getMessage());
        }
    }
}
