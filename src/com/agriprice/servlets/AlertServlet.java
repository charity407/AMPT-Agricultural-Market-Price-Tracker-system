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

@WebServlet("/alerts")
public class AlertServlet extends HttpServlet {

    // Show user's price alerts
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        String sql = """
            SELECT pa.*, p.product_name, m.market_name
            FROM price_alerts pa
            JOIN products p ON pa.product_id = p.product_id
            JOIN markets m ON pa.market_id = m.market_id
            WHERE pa.user_id = ? AND pa.is_active = true
            ORDER BY pa.created_date DESC
            """;

        List<Map<String, Object>> alerts = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> alert = new HashMap<>();
                alert.put("alertId", rs.getInt("alert_id"));
                alert.put("productName", rs.getString("product_name"));
                alert.put("marketName", rs.getString("market_name"));
                alert.put("thresholdPrice", rs.getDouble("threshold_price"));
                alert.put("alertDirection", rs.getString("alert_direction"));
                alert.put("createdDate", rs.getTimestamp("created_date"));
                alerts.add(alert);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load alerts: " + e.getMessage());
        }

        req.setAttribute("alerts", alerts);

        // Fetch products and markets for the create-alert form dropdowns
        List<Map<String, Object>> products = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT product_id, product_name FROM products WHERE is_active = true ORDER BY product_name")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> p = new HashMap<>();
                p.put("productId", rs.getInt("product_id"));
                p.put("productName", rs.getString("product_name"));
                products.add(p);
            }
        } catch (Exception e) { e.printStackTrace(); }

        List<Map<String, Object>> markets = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT market_id, market_name FROM markets WHERE status = 'ACTIVE' ORDER BY market_name")) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("marketId", rs.getInt("market_id"));
                m.put("marketName", rs.getString("market_name"));
                markets.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }

        req.setAttribute("products", products);
        req.setAttribute("markets", markets);
        req.getRequestDispatcher("/jsp/alerts/alerts.jsp").forward(req, resp);
    }

    // Handle alert creation/update
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        String action = req.getParameter("action"); // "create" or "update"

        if ("create".equals(action)) {
            int productId = Integer.parseInt(req.getParameter("productId"));
            int marketId = Integer.parseInt(req.getParameter("marketId"));
            double thresholdPrice = Double.parseDouble(req.getParameter("thresholdPrice"));
            String alertDirection = req.getParameter("alertDirection");

            String sql = """
                INSERT INTO price_alerts (user_id, product_id, market_id, threshold_price, alert_direction)
                VALUES (?, ?, ?, ?, ?)
                """;

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, productId);
                ps.setInt(3, marketId);
                ps.setDouble(4, thresholdPrice);
                ps.setString(5, alertDirection);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/alerts?error=Failed to create alert: " + e.getMessage());
                return;
            }
        } else if ("update".equals(action)) {
            int alertId = Integer.parseInt(req.getParameter("alertId"));
            double thresholdPrice = Double.parseDouble(req.getParameter("thresholdPrice"));
            String alertDirection = req.getParameter("alertDirection");

            String sql = """
                UPDATE price_alerts
                SET threshold_price = ?, alert_direction = ?
                WHERE alert_id = ? AND user_id = ?
                """;

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setDouble(1, thresholdPrice);
                ps.setString(2, alertDirection);
                ps.setInt(3, alertId);
                ps.setInt(4, userId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/alerts?error=Failed to update alert: " + e.getMessage());
                return;
            }
        } else if ("delete".equals(action)) {
            int alertId = Integer.parseInt(req.getParameter("alertId"));
            String sql = "UPDATE price_alerts SET is_active = false WHERE alert_id = ? AND user_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, alertId);
                ps.setInt(2, userId);
                ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendRedirect(req.getContextPath() + "/alerts?error=Failed to delete alert");
                return;
            }
        }

        resp.sendRedirect(req.getContextPath() + "/alerts?success=Alert saved successfully");
    }
}