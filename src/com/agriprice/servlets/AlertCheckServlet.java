package com.agriprice.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.agriprice.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/alerts/check") // Optional: can be called manually or via cron
public class AlertCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // This servlet checks all active alerts and triggers notifications
        // Can be called manually via GET or scheduled via cron

        int alertsTriggered = 0;

        try (Connection conn = DBConnection.getConnection()) {

            // TODO: Query all active price alerts
            // TODO: For each alert, check current price vs threshold
            // TODO: If threshold exceeded, trigger SMS notification via Africa's Talking API
            // TODO: Log triggered alerts

            // Placeholder: Just count how many alerts would be triggered
            alertsTriggered = checkAndTriggerAlerts(conn);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                         "Failed to check alerts: " + e.getMessage());
            return;
        }

        // Return JSON response for API calls
        resp.setContentType("application/json");
        resp.getWriter().write("{\"alertsTriggered\": " + alertsTriggered + ", \"status\": \"success\"}");

    }

    private int checkAndTriggerAlerts(Connection conn) throws SQLException {
        int triggered = 0;

        // Get all active alerts
        String alertSql = """
            SELECT pa.alert_id, pa.user_id, pa.product_id, pa.market_id, pa.threshold_price, pa.alert_direction,
                   p.product_name, m.market_name, u.phone_number
            FROM price_alerts pa
            JOIN products p ON pa.product_id = p.product_id
            JOIN markets m ON pa.market_id = m.market_id
            JOIN users u ON pa.user_id = u.user_id
            WHERE pa.is_active = true
            """;

        // Get latest price for each product/market
        String priceSql = """
            SELECT unit_price FROM price_entries
            WHERE product_id = ? AND market_id = ?
            ORDER BY price_date DESC LIMIT 1
            """;

        try (PreparedStatement alertPs = conn.prepareStatement(alertSql);
             PreparedStatement pricePs = conn.prepareStatement(priceSql)) {

            ResultSet alertRs = alertPs.executeQuery();
            while (alertRs.next()) {
                int productId = alertRs.getInt("product_id");
                int marketId = alertRs.getInt("market_id");
                double threshold = alertRs.getDouble("threshold_price");
                String direction = alertRs.getString("alert_direction");

                pricePs.setInt(1, productId);
                pricePs.setInt(2, marketId);
                ResultSet priceRs = pricePs.executeQuery();
                if (priceRs.next()) {
                    double currentPrice = priceRs.getDouble("unit_price");
                    boolean trigger = false;

                    if ("above".equals(direction) && currentPrice > threshold) {
                        trigger = true;
                    } else if ("below".equals(direction) && currentPrice < threshold) {
                        trigger = true;
                    }

                    if (trigger) {
                        // TODO: Send SMS notification
                        // For now, just log
                        System.out.println("Alert triggered for user " + alertRs.getInt("user_id") +
                                         ": " + alertRs.getString("product_name") + " in " +
                                         alertRs.getString("market_name") + " is " + direction +
                                         " threshold " + threshold + " (current: " + currentPrice + ")");
                        triggered++;
                    }
                }
            }
        }

        return triggered;
    }
}