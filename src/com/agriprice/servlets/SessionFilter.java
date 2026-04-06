package com.agriprice.servlets;

import com.agriprice.utils.DBConnection;
import com.agriprice.utils.PasswordUtil;
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

@WebServlet("/login")
public class SessionFilter extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get email and password from login.html form
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // Basic validation
        if (email == null || password == null ||
                email.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/login.html").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // Look up user by email
            PreparedStatement ps = conn.prepareStatement(
                    "SELECT user_id, full_name, password_hash, role, account_status " +
                            "FROM users WHERE email_address = ?"
            );
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            // Email not found
            if (!rs.next()) {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/login.html").forward(request, response);
                return;
            }

            String storedHash    = rs.getString("password_hash");
            String accountStatus = rs.getString("account_status");
            String role          = rs.getString("role");
            String fullName      = rs.getString("full_name");
            int    userId        = rs.getInt("user_id");

            // Check password is correct
            if (!PasswordUtil.verifyPassword(password, storedHash)) {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/login.html").forward(request, response);
                return;
            }

            // Check account is active
            if ("PENDING".equals(accountStatus)) {
                request.setAttribute("error", "Your account is pending admin approval.");
                request.getRequestDispatcher("/login.html").forward(request, response);
                return;
            }

            if (!"ACTIVE".equals(accountStatus)) {
                request.setAttribute("error", "Your account is not active.");
                request.getRequestDispatcher("/login.html").forward(request, response);
                return;
            }

            // Login successful — create a session
            HttpSession session = request.getSession();
            session.setAttribute("userId",   userId);
            session.setAttribute("fullName", fullName);
            session.setAttribute("role",     role);
            session.setAttribute("email",    email);

            // Redirect to dashboard
            response.sendRedirect(request.getContextPath() + "/jsp/dashboard.jsp");

        } catch (Exception e) {
            System.err.println("[SessionFilter] Error: " + e.getMessage());
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.getRequestDispatcher("/login.html").forward(request, response);
        }
    }

    // Redirect to login if someone tries to access login page directly
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            // Already logged in — go to dashboard
            response.sendRedirect(request.getContextPath() + "/jsp/dashboard.jsp");
        } else {
            // Not logged in — show login page
            request.getRequestDispatcher("/login.html").forward(request, response);
        }
    }
}