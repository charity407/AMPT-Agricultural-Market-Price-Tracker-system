package com.agriprice.servlets;

import java.io.IOException;
import java.io.PrintWriter;
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
            // TODO: Generate summary report
            // TODO: Set report data as request attributes
            // TODO: Forward to report JSP

            try {
                req.getRequestDispatcher("/jsp/reports/summary.jsp").forward(req, resp);
            } catch (Exception e) {
                e.printStackTrace();
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to generate report");
            }
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