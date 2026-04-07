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


public class PriceCompareServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        String productIdParam = req.getParameter("productId");
        String marketIdsParam = req.getParameter("marketIds"); // comma-separated

        // Load products and markets for the selection form (always needed)
        List<String[]> products = new ArrayList<>();
        List<String[]> markets  = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT product_id, product_name FROM products WHERE is_active = true ORDER BY product_name");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    products.add(new String[]{ rs.getString("product_id"), rs.getString("product_name") });
            }
            try (PreparedStatement ps = conn.prepareStatement(
                    "SELECT market_id, market_name FROM markets WHERE status = 'ACTIVE' ORDER BY market_name");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    markets.add(new String[]{ rs.getString("market_id"), rs.getString("market_name") });
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        req.setAttribute("products", products);
        req.setAttribute("markets",  markets);

        // If no params yet, just show the selection form
        if (productIdParam == null || productIdParam.isEmpty()
                || marketIdsParam == null || marketIdsParam.isEmpty()) {
            req.getRequestDispatcher("/jsp/prices/compare.jsp").forward(req, resp);
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        String[] marketIdStrings = marketIdsParam.split(",");
        List<Integer> marketIds = new ArrayList<>();
        for (String id : marketIdStrings) {
            if (!id.trim().isEmpty()) marketIds.add(Integer.parseInt(id.trim()));
        }

        // Query latest prices for the product in each market
        String sql = """
            SELECT pe.unit_price, m.market_name, pe.price_date
            FROM price_entries pe
            JOIN markets m ON pe.market_id = m.market_id
            WHERE pe.product_id = ? AND pe.market_id = ?
            ORDER BY pe.price_date DESC
            LIMIT 1
            """;

        List<String[]> comparisonData = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            for (int marketId : marketIds) {
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, productId);
                    ps.setInt(2, marketId);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        comparisonData.add(new String[] {
                            rs.getString("market_name"),
                            rs.getString("unit_price"),
                            rs.getString("price_date")
                        });
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load price comparison: " + e.getMessage());
        }

        req.setAttribute("comparisonData", comparisonData);
        req.getRequestDispatcher("/jsp/prices/compare.jsp").forward(req, resp);
    }
}