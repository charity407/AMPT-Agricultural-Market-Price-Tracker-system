package com.agriprice.servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.agriprice.utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/prices/edit")
public class PriceEditServlet extends HttpServlet {

    // Show the edit form for a specific price entry
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        String entryIdParam = req.getParameter("id");
        if (entryIdParam == null || entryIdParam.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/prices/list?error=No entry ID provided");
            return;
        }

        int entryId = Integer.parseInt(entryIdParam);

        String sql = """
            SELECT pe.*, p.product_name, m.market_name
            FROM price_entries pe
            JOIN products p ON pe.product_id = p.product_id
            JOIN markets m ON pe.market_id = m.market_id
            WHERE pe.entry_id = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, entryId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                req.setAttribute("entryId", rs.getInt("entry_id"));
                req.setAttribute("productId", rs.getInt("product_id"));
                req.setAttribute("productName", rs.getString("product_name"));
                req.setAttribute("marketId", rs.getInt("market_id"));
                req.setAttribute("marketName", rs.getString("market_name"));
                req.setAttribute("unitPrice", rs.getDouble("unit_price"));
                req.setAttribute("priceDate", rs.getDate("price_date"));
                req.setAttribute("notes", rs.getString("notes"));
            } else {
                resp.sendRedirect(req.getContextPath() + "/prices/list?error=Price entry not found");
                return;
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to load price entry");
            return;
        }

        req.getRequestDispatcher("/jsp/prices/edit.jsp").forward(req, resp);
    }

    // Handle edit form submission
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        int entryId = Integer.parseInt(req.getParameter("entryId"));
        double unitPrice = Double.parseDouble(req.getParameter("unitPrice"));
        String priceDate = req.getParameter("priceDate");
        String notes = req.getParameter("notes");

        String sql = """
            UPDATE price_entries
            SET unit_price = ?, price_date = ?, notes = ?
            WHERE entry_id = ?
            """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, unitPrice);
            ps.setDate(2, Date.valueOf(priceDate));
            ps.setString(3, notes);
            ps.setInt(4, entryId);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                resp.sendRedirect(req.getContextPath() + "/prices/list?success=Price updated successfully");
            } else {
                resp.sendRedirect(req.getContextPath() + "/prices/list?error=Price entry not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/prices/list?error=Failed to update price: " + e.getMessage());
        }
    }
}