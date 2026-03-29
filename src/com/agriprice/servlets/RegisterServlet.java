package com.agriprice.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.agriprice.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.html").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role"); // e.g., FARMER, AGENT

        if (fullName == null || email == null || password == null || role == null ||
                fullName.isEmpty() || email.isEmpty() || password.isEmpty() || role.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/register?error=All fields required");
            return;
        }

        // Validate email format
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            resp.sendRedirect(req.getContextPath() + "/register?error=Invalid email format");
            return;
        }

        // Validate password strength (at least 6 characters)
        if (password.length() < 6) {
            resp.sendRedirect(req.getContextPath() + "/register?error=Password must be at least 6 characters");
            return;
        }

        // Validate role
        if (!role.equals("FARMER") && !role.equals("AGENT") && !role.equals("ADMIN")) {
            resp.sendRedirect(req.getContextPath() + "/register?error=Invalid role");
            return;
        }

        String sql = "INSERT INTO users (full_name, email_address, password_hash, role) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, password); // In production, hash the password
            ps.setString(4, role);

            ps.executeUpdate();
            resp.sendRedirect(req.getContextPath() + "/login?success=Registration successful");

        } catch (SQLException e) {
            if (e.getSQLState().equals("23505")) { // Unique violation
                resp.sendRedirect(req.getContextPath() + "/register?error=Email already exists");
            } else {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/register?error=Registration failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/register?error=Registration failed");
        }
    }
}
