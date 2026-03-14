package com.agriprice.servlets;

import com.agriprice.models.User;
import com.agriprice.utils.DBConnection;
import com.agriprice.utils.PasswordUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form fields from register.html
        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String role     = request.getParameter("role");
        String password = request.getParameter("password");

        // Basic validation
        if (fullName == null || email == null || role == null || password == null ||
                fullName.isEmpty() || email.isEmpty() || role.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/register.html").forward(request, response);
            return;
        }

        if (password.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters.");
            request.getRequestDispatcher("/register.html").forward(request, response);
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            // Check if email already exists
            PreparedStatement check = conn.prepareStatement(
                    "SELECT user_id FROM users WHERE email_address = ?"
            );
            check.setString(1, email);
            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                request.setAttribute("error", "Email is already registered.");
                request.getRequestDispatcher("/register.html").forward(request, response);
                return;
            }

            // Hash the password
            String hashedPassword = PasswordUtil.hashPassword(password);

            // MARKET_AGENT accounts need admin approval
            String status = role.equals("MARKET_AGENT") ? "PENDING" : "ACTIVE";

            // Insert new user into database
            PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO users (full_name, email_address, password_hash, role, account_status, is_verified) " +
                            "VALUES (?, ?, ?, ?, ?, ?)"
            );
            insert.setString(1, fullName);
            insert.setString(2, email);
            insert.setString(3, hashedPassword);
            insert.setString(4, role);
            insert.setString(5, status);
            insert.setBoolean(6, false);
            insert.executeUpdate();

            // Redirect to login page after successful registration
            response.sendRedirect(request.getContextPath() + "/login.html");

        } catch (Exception e) {
            System.err.println("[RegisterServlet] Error: " + e.getMessage());
            request.setAttribute("error", "Something went wrong. Please try again.");
            request.getRequestDispatcher("/register.html").forward(request, response);
        }
    }
}