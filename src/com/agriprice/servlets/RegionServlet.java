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


public class RegionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        if (session.getAttribute("userId") == null) {
            resp.sendRedirect(req.getContextPath() + "/login?error=Please login first");
            return;
        }

        try {
            List<Object[]> regions = new ArrayList<>();
            String sql = "SELECT region_id, region_name FROM regions ORDER BY region_name";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    regions.add(new Object[]{
                        rs.getInt("region_id"),
                        rs.getString("region_name")
                    });
                }
            }

            req.setAttribute("regions", regions);
            req.getRequestDispatcher("/jsp/admin/regions.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading regions: " + e.getMessage());
            try {
                req.getRequestDispatcher("/jsp/admin/regions.jsp").forward(req, resp);
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

        try {
            String action = req.getParameter("action");

            if ("add".equals(action)) {
                String regionName = req.getParameter("regionName");

                String sql = "INSERT INTO regions (region_name) VALUES (?)";

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, regionName);
                    ps.executeUpdate();
                }

                resp.sendRedirect(req.getContextPath() + "/admin/regions?success=Region added");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/regions?error=" + e.getMessage());
        }
    }
}
