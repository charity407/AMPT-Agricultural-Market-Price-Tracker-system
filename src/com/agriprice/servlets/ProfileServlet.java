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
import java.sql.*;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    // GET /profile — load user data and display profile page
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps = conn.prepareStatement(
                    "SELECT full_name, email_address, phone_number, preferred_language, " +
                            "role, account_status, registration_date FROM users WHERE user_id = ?"
            );
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("fullName",          rs.getString("full_name"));
                request.setAttribute("emailAddress",      rs.getString("email_address"));
                request.setAttribute("phoneNumber",       rs.getString("phone_number"));
                request.setAttribute("preferredLanguage", rs.getString("preferred_language"));
                request.setAttribute("role",              rs.getString("role"));
                request.setAttribute("accountStatus",     rs.getString("account_status"));
                request.setAttribute("registrationDate",  rs.getString("registration_date"));
            }

            request.getRequestDispatcher("/jsp/profile/index.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[ProfileServlet] GET error: " + e.getMessage());
            request.setAttribute("error", "Failed to load profile.");
            request.getRequestDispatcher("/jsp/profile/index.jsp").forward(request, response);
        }
    }

    // POST /profile — update profile info OR change password
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login.html");
            return;
        }

        int    userId = (int) session.getAttribute("userId");
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {

            if ("updateProfile".equals(action)) {

                String fullName    = request.getParameter("fullName");
                String phoneNumber = request.getParameter("phoneNumber");

                if (fullName == null || fullName.trim().isEmpty()) {
                    request.setAttribute("error", "Full name cannot be empty.");
                    doGet(request, response);
                    return;
                }

                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE users SET full_name = ?, phone_number = ? WHERE user_id = ?"
                );
                ps.setString(1, fullName.trim());
                ps.setString(2, phoneNumber != null ? phoneNumber.trim() : null);
                ps.setInt(3, userId);
                ps.executeUpdate();

                // Update session so navbar shows new name right away
                session.setAttribute("userName", fullName.trim());
                request.setAttribute("success", "Profile updated successfully.");

            } else if ("changePassword".equals(action)) {

                String oldPass  = request.getParameter("oldPassword");
                String newPass  = request.getParameter("newPassword");
                String confPass = request.getParameter("confirmPassword");

                // Validate all fields present
                if (isBlank(oldPass) || isBlank(newPass) || isBlank(confPass)) {
                    request.setAttribute("error", "All password fields are required.");
                    doGet(request, response);
                    return;
                }

                // New passwords must match
                if (!newPass.equals(confPass)) {
                    request.setAttribute("error", "New passwords do not match.");
                    doGet(request, response);
                    return;
                }

                // Minimum length
                if (newPass.length() < 8) {
                    request.setAttribute("error", "New password must be at least 8 characters.");
                    doGet(request, response);
                    return;
                }

                // Verify old password is correct
                PreparedStatement check = conn.prepareStatement(
                        "SELECT password_hash FROM users WHERE user_id = ?"
                );
                check.setInt(1, userId);
                ResultSet rs = check.executeQuery();

                if (!rs.next() || !PasswordUtil.verifyPassword(oldPass, rs.getString("password_hash"))) {
                    request.setAttribute("error", "Current password is incorrect.");
                    doGet(request, response);
                    return;
                }

                // Save new hashed password
                PreparedStatement update = conn.prepareStatement(
                        "UPDATE users SET password_hash = ? WHERE user_id = ?"
                );
                update.setString(1, PasswordUtil.hashPassword(newPass));
                update.setInt(2, userId);
                update.executeUpdate();

                request.setAttribute("success", "Password changed successfully.");
            }

            doGet(request, response);

        } catch (Exception e) {
            System.err.println("[ProfileServlet] POST error: " + e.getMessage());
            request.setAttribute("error", "Something went wrong. Please try again.");
            doGet(request, response);
        }
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
