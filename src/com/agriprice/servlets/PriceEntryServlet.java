package com.agriprice.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;

import com.agriprice.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/prices/entry")
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

        try {
            req.getRequestDispatcher("/jsp/prices/entry.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
        }
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
