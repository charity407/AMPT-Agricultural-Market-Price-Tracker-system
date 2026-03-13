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

@WebServlet("/prices/list")
public class PriceListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String cropName = req.getParameter("cropName");
        String region = req.getParameter("region");
        String market = req.getParameter("market");
        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");

        StringBuilder sql = new StringBuilder("SELECT * FROM price_entries WHERE 1=1");

        if (cropName != null && !cropName.isEmpty())
            sql.append(" AND crop_name = ?");
        if (region != null && !region.isEmpty())
            sql.append(" AND region = ?");
        if (market != null && !market.isEmpty())
            sql.append(" AND market = ?");
        if (fromDate != null && !fromDate.isEmpty())
            sql.append(" AND date_recorded >= ?");
        if (toDate != null && !toDate.isEmpty())
            sql.append(" AND date_recorded <= ?");

        sql.append(" ORDER BY date_recorded DESC");

        List<String[]> priceList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            if (cropName != null && !cropName.isEmpty())
                ps.setString(i++, cropName);
            if (region != null && !region.isEmpty())
                ps.setString(i++, region);
            if (market != null && !market.isEmpty())
                ps.setString(i++, market);
            if (fromDate != null && !fromDate.isEmpty())
                ps.setDate(i++, Date.valueOf(fromDate));
            if (toDate != null && !toDate.isEmpty())
                ps.setDate(i++, Date.valueOf(toDate));

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                priceList.add(new String[] {
                        rs.getString("crop_name"),
                        rs.getString("price"),
                        rs.getString("market"),
                        rs.getString("region"),
                        rs.getString("date_recorded")
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
