package com.agriprice.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.agriprice.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class PriceTrendServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        String productIdParam = req.getParameter("productId");
        String marketIdParam = req.getParameter("marketId");
        String daysParam = req.getParameter("days"); // e.g., 30, 90, 180

        if (productIdParam == null || marketIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/prices/list?error=Missing parameters for trends");
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        int marketId = Integer.parseInt(marketIdParam);
        int days = daysParam != null ? Integer.parseInt(daysParam) : 30;

        // Query historical prices
        String sql = """
            SELECT price_date, unit_price
            FROM price_entries
            WHERE product_id = ? AND market_id = ?
            AND price_date >= CURRENT_DATE - INTERVAL '%d days'
            ORDER BY price_date
            """.formatted(days);

        List<String[]> trendData = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, marketId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                trendData.add(new String[] {
                    rs.getString("price_date"),
                    rs.getString("unit_price")
                });
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load price trends: " + e.getMessage());
        }

        req.setAttribute("trendData", trendData);
        req.setAttribute("days", days);
        req.getRequestDispatcher("/jsp/trends/trends.jsp").forward(req, resp);
    }
}