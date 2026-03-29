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
public class LoginServlet extends HttpServlet {

    // GET /login — show login page (redirect to dashboard if already logged in)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("userId") != null) {
            response.sendRedirect(request.getContextPath() + "/jsp/dashboard.jsp");
            return;
        }
        request.getRequestDispatcher("/login.html").forward(request, response);
    }

    // POST /login — verify credentials and create session
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // Edge case: empty fields
        if (isBlank(email) || isBlank(password)) {
            forward(request, response, "Email and password are required.");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps = conn.prepareStatement(
                    "SELECT user_id, full_name, password_hash, role, account_status " +
                            "FROM users WHERE email_address = ?"
            );
            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();

            // Edge case: email not found
            if (!rs.next()) {
                forward(request, response, "Invalid email or password.");
                return;
            }

            String storedHash    = rs.getString("password_hash");
            String accountStatus = rs.getString("account_status");
            String role          = rs.getString("role");
            String fullName      = rs.getString("full_name");
            int    userId        = rs.getInt("user_id");

            // Edge case: wrong password
            if (!PasswordUtil.verifyPassword(password, storedHash)) {
                forward(request, response, "Invalid email or password.");
                return;
            }

            // Edge case: pending account
            if ("PENDING".equals(accountStatus)) {
                forward(request, response, "Your account is pending admin approval.");
                return;
            }

            // Edge case: inactive / suspended account
            if (!"ACTIVE".equals(accountStatus)) {
                forward(request, response, "Your account is not active. Please contact support.");
                return;
            }

            // All checks passed — create session
            // NOTE: These exact attribute names are used by ALL team members
            HttpSession session = request.getSession();
            session.setAttribute("userId",   userId);
            session.setAttribute("userRole", role);
            session.setAttribute("userName", fullName);

            // Admins go to user management, everyone else to dashboard
            if ("ADMIN".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/users");
            } else {
                response.sendRedirect(request.getContextPath() + "/jsp/dashboard.jsp");
            }

        } catch (Exception e) {
            System.err.println("[LoginServlet] Error: " + e.getMessage());
            forward(request, response, "Something went wrong. Please try again.");
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse res,
                         String error) throws ServletException, IOException {
        req.setAttribute("error", error);
        req.getRequestDispatcher("/login.html").forward(req, res);
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
