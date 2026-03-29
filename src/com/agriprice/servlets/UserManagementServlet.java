package com.agriprice.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.agriprice.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/users")
public class UserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String userRole = (String) session.getAttribute("userRole");

        if (!"ADMIN".equals(userRole)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            int userId = Integer.parseInt(req.getParameter("id"));
            // Load user for editing
            String sql = "SELECT * FROM users WHERE user_id = ?";
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    req.setAttribute("userId", rs.getInt("user_id"));
                    req.setAttribute("fullName", rs.getString("full_name"));
                    req.setAttribute("email", rs.getString("email_address"));
                    req.setAttribute("role", rs.getString("role"));
                    req.setAttribute("status", rs.getString("account_status"));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            req.getRequestDispatcher("/jsp/admin/users/edit.jsp").forward(req, resp);
        } else {
            // List users
            List<Map<String, Object>> users = new ArrayList<>();
            String sql = "SELECT user_id, full_name, email_address, role, account_status FROM users ORDER BY user_id";
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("userId", rs.getInt("user_id"));
                    user.put("fullName", rs.getString("full_name"));
                    user.put("email", rs.getString("email_address"));
                    user.put("role", rs.getString("role"));
                    user.put("status", rs.getString("account_status"));
                    users.add(user);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            req.setAttribute("users", users);
            req.getRequestDispatcher("/jsp/admin/users/list.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String userRole = (String) session.getAttribute("userRole");

        if (!"ADMIN".equals(userRole)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String action = req.getParameter("action");

        if ("update".equals(action)) {
            int userId = Integer.parseInt(req.getParameter("userId"));
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String role = req.getParameter("role");
            String status = req.getParameter("status");

            String sql = "UPDATE users SET full_name = ?, email_address = ?, role = ?, account_status = ? WHERE user_id = ?";
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, fullName);
                ps.setString(2, email);
                ps.setString(3, role);
                ps.setString(4, status);
                ps.setInt(5, userId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("delete".equals(action)) {
            int userId = Integer.parseInt(req.getParameter("userId"));
            String sql = "DELETE FROM users WHERE user_id = ?";
            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
