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

@WebServlet("/prices/compare")
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

        if (productIdParam == null || marketIdsParam == null) {
            resp.sendRedirect(req.getContextPath() + "/prices/list?error=Missing parameters for comparison");
            return;
        }

        int productId = Integer.parseInt(productIdParam);
        String[] marketIdStrings = marketIdsParam.split(",");
        List<Integer> marketIds = new ArrayList<>();
        for (String id : marketIdStrings) {
            marketIds.add(Integer.parseInt(id.trim()));
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