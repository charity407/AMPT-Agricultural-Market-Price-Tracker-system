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


public class MarketServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!("ADMIN".equals(userRole))) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Admin access required");
            return;
        }

        try {
            List<Object[]> marketList = new ArrayList<>();
            String sql = "SELECT m.market_id, m.market_name, m.town, r.region_name, m.operating_days, m.status " +
                        "FROM markets m " +
                        "LEFT JOIN regions r ON m.region_id = r.region_id " +
                        "ORDER BY m.market_name";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    marketList.add(new Object[]{
                        rs.getInt("market_id"),
                        rs.getString("market_name"),
                        rs.getString("town"),
                        rs.getString("region_name"),
                        rs.getString("operating_days"),
                        rs.getString("status")
                    });
                }
            }

            req.setAttribute("marketList", marketList);
            req.getRequestDispatcher("/jsp/admin/markets.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading markets: " + e.getMessage());
            try {
                req.getRequestDispatcher("/jsp/admin/markets.jsp").forward(req, resp);
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        String userRole = (String) session.getAttribute("userRole");
        if (!("ADMIN".equals(userRole))) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Admin access required");
            return;
        }

        try {
            String action = req.getParameter("action");

            if ("add".equals(action)) {
                String marketName = req.getParameter("marketName");
                String town = req.getParameter("town");
                int regionId = Integer.parseInt(req.getParameter("regionId"));
                String operatingDays = req.getParameter("operatingDays");

                String sql = "INSERT INTO markets (market_name, town, region_id, operating_days, status, date_registered) " +
                           "VALUES (?, ?, ?, ?, 'ACTIVE', NOW())";

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, marketName);
                    ps.setString(2, town);
                    ps.setInt(3, regionId);
                    ps.setString(4, operatingDays);
                    ps.executeUpdate();
                }

                resp.sendRedirect(req.getContextPath() + "/admin/markets?success=Market added");
            } else if ("delete".equals(action)) {
                int marketId = Integer.parseInt(req.getParameter("marketId"));

                String sql = "UPDATE markets SET status = 'INACTIVE' WHERE market_id = ?";

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, marketId);
                    ps.executeUpdate();
                }

                resp.sendRedirect(req.getContextPath() + "/admin/markets?success=Market deactivated");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/markets?error=" + e.getMessage());
        }
    }
}
