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


public class PriceListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        String cropName = req.getParameter("cropName");
        String region = req.getParameter("region");
        String market = req.getParameter("market");
        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");

        StringBuilder sql = new StringBuilder("""
                SELECT pe.entry_id, p.product_name, pe.unit_price, m.market_name, r.region_name, pe.price_date
                FROM price_entries pe
                JOIN products p ON pe.product_id = p.product_id
                JOIN markets m ON pe.market_id = m.market_id
                JOIN regions r ON m.region_id = r.region_id
                WHERE 1=1
                """);

        if (cropName != null && !cropName.isEmpty())
            sql.append(" AND p.product_name ILIKE ?");
        if (region != null && !region.isEmpty())
            sql.append(" AND r.region_name ILIKE ?");
        if (market != null && !market.isEmpty())
            sql.append(" AND m.market_name ILIKE ?");
        if (fromDate != null && !fromDate.isEmpty())
            sql.append(" AND pe.price_date >= ?");
        if (toDate != null && !toDate.isEmpty())
            sql.append(" AND pe.price_date <= ?");

        sql.append(" ORDER BY pe.price_date DESC");

        List<String[]> priceList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            if (cropName != null && !cropName.isEmpty())
                ps.setString(i++, "%" + cropName + "%");
            if (region != null && !region.isEmpty())
                ps.setString(i++, "%" + region + "%");
            if (market != null && !market.isEmpty())
                ps.setString(i++, "%" + market + "%");
            if (fromDate != null && !fromDate.isEmpty())
                ps.setDate(i++, Date.valueOf(fromDate));
            if (toDate != null && !toDate.isEmpty())
                ps.setDate(i++, Date.valueOf(toDate));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                priceList.add(new String[] {
                        rs.getString("product_name"),
                        rs.getString("unit_price"),
                        rs.getString("market_name"),
                        rs.getString("region_name"),
                        rs.getString("price_date")
                });
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to load prices: " + e.getMessage());
        }

        req.setAttribute("priceList", priceList);
        req.getRequestDispatcher("/jsp/prices/list.jsp").forward(req, resp);
    }
}
