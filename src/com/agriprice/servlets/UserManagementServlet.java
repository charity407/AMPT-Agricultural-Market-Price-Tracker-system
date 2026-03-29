package com.agriprice.servlets;

import com.agriprice.utils.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {

    // GET /admin/users — load all users and display in admin JSP
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        try (Connection conn = DBConnection.getConnection()) {

            PreparedStatement ps = conn.prepareStatement(
                    "SELECT user_id, full_name, email_address, role, " +
                            "account_status, is_verified, registration_date " +
                            "FROM users ORDER BY registration_date DESC"
            );

            ResultSet rs = ps.executeQuery();
            List<Map<String, Object>> users = new ArrayList<>();

            while (rs.next()) {
                Map<String, Object> user = new LinkedHashMap<>();
                user.put("userId",           rs.getInt("user_id"));
                user.put("fullName",         rs.getString("full_name"));
                user.put("emailAddress",     rs.getString("email_address"));
                user.put("role",             rs.getString("role"));
                user.put("accountStatus",    rs.getString("account_status"));
                user.put("isVerified",       rs.getBoolean("is_verified"));
                user.put("registrationDate", rs.getString("registration_date"));
                users.add(user);
            }

            request.setAttribute("users", users);
            request.getRequestDispatcher("/jsp/admin/users.jsp").forward(request, response);

        } catch (Exception e) {
            System.err.println("[UserManagementServlet] Error: " + e.getMessage());
            request.setAttribute("error", "Failed to load users.");
            request.getRequestDispatcher("/jsp/admin/users.jsp").forward(request, response);
        }
    }

    // POST /admin/users — activate / deactivate / change role
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) return;

        String action      = request.getParameter("action");
        String userIdParam = request.getParameter("userId");

        if (action == null || userIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        int targetId;
        try {
            targetId = Integer.parseInt(userIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin/users");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {

            switch (action) {

                case "activate":
                    runUpdate(conn,
                            "UPDATE users SET account_status = 'ACTIVE' WHERE user_id = ?",
                            targetId);
                    break;

                case "deactivate":
                    runUpdate(conn,
                            "UPDATE users SET account_status = 'INACTIVE' WHERE user_id = ?",
                            targetId);
                    break;

                case "changeRole":
                    String newRole = request.getParameter("role");
                    if (newRole != null && !newRole.isEmpty()) {
                        PreparedStatement ps = conn.prepareStatement(
                                "UPDATE users SET role = ? WHERE user_id = ?"
                        );
                        ps.setString(1, newRole);
                        ps.setInt(2, targetId);
                        ps.executeUpdate();
                    }
                    break;
            }

            response.sendRedirect(request.getContextPath() + "/admin/users");

        } catch (Exception e) {
            System.err.println("[UserManagementServlet] Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/admin/users");
        }
    }

    private void runUpdate(Connection conn, String sql, int id) throws SQLException {
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
    }

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            res.sendRedirect(req.getContextPath() + "/login.html");
            return false;
        }
        if (!"ADMIN".equals(session.getAttribute("userRole"))) {
            res.sendRedirect(req.getContextPath() + "/jsp/dashboard.jsp");
            return false;
        }
        return true;
    }
}
