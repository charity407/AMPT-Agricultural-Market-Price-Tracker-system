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

@WebServlet("/admin/products")
public class ProductServlet extends HttpServlet {

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
            List<Object[]> productList = new ArrayList<>();
            String sql = "SELECT p.product_id, p.product_name, c.category_name, p.standard_unit, p.is_active " +
                        "FROM products p " +
                        "LEFT JOIN product_categories c ON p.category_id = c.category_id " +
                        "ORDER BY p.product_name";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    productList.add(new Object[]{
                        rs.getInt("product_id"),
                        rs.getString("product_name"),
                        rs.getString("category_name"),
                        rs.getString("standard_unit"),
                        rs.getBoolean("is_active")
                    });
                }
            }

            req.setAttribute("productList", productList);
            req.getRequestDispatcher("/jsp/admin/products.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error loading products: " + e.getMessage());
            try {
                req.getRequestDispatcher("/jsp/admin/products.jsp").forward(req, resp);
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
                String productName = req.getParameter("productName");
                int categoryId = Integer.parseInt(req.getParameter("categoryId"));
                String unit = req.getParameter("unit");

                String sql = "INSERT INTO products (product_name, category_id, standard_unit, is_active, date_added) " +
                           "VALUES (?, ?, ?, true, NOW())";

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, productName);
                    ps.setInt(2, categoryId);
                    ps.setString(3, unit);
                    ps.executeUpdate();
                }

                resp.sendRedirect(req.getContextPath() + "/admin/products?success=Product added");
            } else if ("delete".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));

                String sql = "UPDATE products SET is_active = false WHERE product_id = ?";

                try (Connection conn = DBConnection.getConnection();
                     PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, productId);
                    ps.executeUpdate();
                }

                resp.sendRedirect(req.getContextPath() + "/admin/products?success=Product deleted");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/products?error=" + e.getMessage());
        }
    }
}
