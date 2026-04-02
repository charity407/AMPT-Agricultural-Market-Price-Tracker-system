package com.agriprice.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
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


public class PriceEntryServlet extends HttpServlet {

    // Show the entry form
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        List<String[]> products = new ArrayList<>();
        List<String[]> markets  = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement ps1 = conn.prepareStatement(
                "SELECT product_id, product_name FROM products WHERE is_active = true ORDER BY product_name");
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                products.add(new String[]{ rs1.getString("product_id"), rs1.getString("product_name") });
            }

            PreparedStatement ps2 = conn.prepareStatement(
                "SELECT market_id, market_name FROM markets WHERE status = 'ACTIVE' ORDER BY market_name");
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                markets.add(new String[]{ rs2.getString("market_id"), rs2.getString("market_name") });
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Could not load products/markets: " + e.getMessage());
        }

        req.setAttribute("products", products);
        req.setAttribute("markets", markets);
        req.getRequestDispatcher("/jsp/prices/entry.jsp").forward(req, resp);
    }

    // Handle form submission
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        int productId = Integer.parseInt(req.getParameter("productId"));
        int marketId = Integer.parseInt(req.getParameter("marketId"));
        double price = Double.parseDouble(req.getParameter("price"));
        String date = req.getParameter("priceDate");

        // Get the logged-in user's ID from session
        int agentId = (int) session.getAttribute("userId");

        String sql = """
                INSERT INTO price_entries
                    (product_id, market_id, agent_id, unit_price, price_date)
                VALUES (?, ?, ?, ?, ?)
                ON CONFLICT (product_id, market_id, price_date)
                DO UPDATE SET unit_price = EXCLUDED.unit_price
                """;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setInt(2, marketId);
            ps.setInt(3, agentId);
            ps.setDouble(4, price);
            ps.setDate(5, Date.valueOf(date));
            ps.executeUpdate();
            resp.sendRedirect(req.getContextPath() + "/prices/list?success=1");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to save price: " + e.getMessage());
            try {
                req.getRequestDispatcher("/jsp/prices/entry.jsp").forward(req, resp);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
