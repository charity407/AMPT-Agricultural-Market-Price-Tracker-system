package com.agriprice.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.Date;
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

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        String userRole = (String) session.getAttribute("userRole");

        // Check permissions - only ADMIN and AGENT can access reports
        if (userRole == null || (!"ADMIN".equals(userRole) && !"AGENT".equals(userRole))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
            return;
        }

        String reportType = req.getParameter("type"); // "csv" or "summary"
        String productIdParam = req.getParameter("productId");
        String marketIdParam = req.getParameter("marketId");
        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");

        if ("csv".equals(reportType)) {
            generateCSVReport(resp, productIdParam, marketIdParam, fromDate, toDate);
        } else {
            generateSummaryReport(req, resp, productIdParam, marketIdParam, fromDate, toDate);
        }
    }

    private void generateSummaryReport(HttpServletRequest req, HttpServletResponse resp,
                                        String productIdParam, String marketIdParam,
                                        String fromDate, String toDate)
            throws ServletException, IOException {

        // Summary stats: total entries, avg price, min, max per product
        StringBuilder sql = new StringBuilder("""
            SELECT p.product_name, m.market_name,
                   COUNT(*) AS total_entries,
                   ROUND(AVG(pe.unit_price)::numeric, 2) AS avg_price,
                   MIN(pe.unit_price) AS min_price,
                   MAX(pe.unit_price) AS max_price,
                   MAX(pe.price_date) AS latest_date
            FROM price_entries pe
            JOIN products p ON pe.product_id = p.product_id
            JOIN markets m ON pe.market_id = m.market_id
            WHERE 1=1
            """);

        if (productIdParam != null && !productIdParam.isEmpty())
            sql.append(" AND pe.product_id = ").append(Integer.parseInt(productIdParam));
        if (marketIdParam != null && !marketIdParam.isEmpty())
            sql.append(" AND pe.market_id = ").append(Integer.parseInt(marketIdParam));
        if (fromDate != null && !fromDate.isEmpty())
            sql.append(" AND pe.price_date >= '").append(fromDate).append("'");
        if (toDate != null && !toDate.isEmpty())
            sql.append(" AND pe.price_date <= '").append(toDate).append("'");

        sql.append(" GROUP BY p.product_name, m.market_name ORDER BY p.product_name, m.market_name");

        List<Map<String, Object>> summary = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString());
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("productName", rs.getString("product_name"));
                row.put("marketName", rs.getString("market_name"));
                row.put("totalEntries", rs.getInt("total_entries"));
                row.put("avgPrice", rs.getDouble("avg_price"));
                row.put("minPrice", rs.getDouble("min_price"));
                row.put("maxPrice", rs.getDouble("max_price"));
                row.put("latestDate", rs.getDate("latest_date"));
                summary.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error generating report: " + e.getMessage());
        }

        // Populate product/market dropdowns for the filter form
        List<Map<String, Object>> products = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT product_id, product_name FROM products WHERE is_active=true ORDER BY product_name");
             ResultSet rs = ps.executeQuery()) {
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
                     "SELECT market_id, market_name FROM markets WHERE status='ACTIVE' ORDER BY market_name");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                m.put("marketId", rs.getInt("market_id"));
                m.put("marketName", rs.getString("market_name"));
                markets.add(m);
            }
        } catch (Exception e) { e.printStackTrace(); }

        req.setAttribute("summary", summary);
        req.setAttribute("products", products);
        req.setAttribute("markets", markets);
        req.setAttribute("filterProduct", productIdParam);
        req.setAttribute("filterMarket", marketIdParam);
        req.setAttribute("filterFrom", fromDate);
        req.setAttribute("filterTo", toDate);

        try {
            req.getRequestDispatcher("/jsp/reports/summary.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to generate report");
        }
    }

    private void generateCSVReport(HttpServletResponse resp, String productIdParam,
                                 String marketIdParam, String fromDate, String toDate)
            throws IOException {

        resp.setContentType("text/csv");
        resp.setHeader("Content-Disposition", "attachment; filename=\"price-report.csv\"");

        PrintWriter writer = resp.getWriter();
        writer.println("Product,Market,Price,Date,Agent");

        StringBuilder sql = new StringBuilder("""
            SELECT p.product_name, m.market_name, pe.unit_price, pe.price_date, u.full_name
            FROM price_entries pe
            JOIN products p ON pe.product_id = p.product_id
            JOIN markets m ON pe.market_id = m.market_id
            JOIN users u ON pe.agent_id = u.user_id
            WHERE 1=1
            """);

        if (productIdParam != null && !productIdParam.isEmpty()) {
            sql.append(" AND pe.product_id = ?");
        }
        if (marketIdParam != null && !marketIdParam.isEmpty()) {
            sql.append(" AND pe.market_id = ?");
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sql.append(" AND pe.price_date >= ?");
        }
        if (toDate != null && !toDate.isEmpty()) {
            sql.append(" AND pe.price_date <= ?");
        }

        sql.append(" ORDER BY pe.price_date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            if (productIdParam != null && !productIdParam.isEmpty()) {
                ps.setInt(i++, Integer.parseInt(productIdParam));
            }
            if (marketIdParam != null && !marketIdParam.isEmpty()) {
                ps.setInt(i++, Integer.parseInt(marketIdParam));
            }
            if (fromDate != null && !fromDate.isEmpty()) {
                ps.setDate(i++, Date.valueOf(fromDate));
            }
            if (toDate != null && !toDate.isEmpty()) {
                ps.setDate(i++, Date.valueOf(toDate));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                writer.println("\"" + rs.getString("product_name") + "\",\"" +
                             rs.getString("market_name") + "\"," +
                             rs.getDouble("unit_price") + "," +
                             rs.getDate("price_date") + ",\"" +
                             rs.getString("full_name") + "\"");
            }
        } catch (Exception e) {
            e.printStackTrace();
            writer.println("Error generating report: " + e.getMessage());
        }

        writer.flush();
    }
}