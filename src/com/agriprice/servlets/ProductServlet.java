package com.agriprice.servlets;

import com.agriprice.models.Product;
import com.agriprice.utils.DBConnection;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/products")
public class ProductServlet extends HttpServlet {

    private final Gson gson = new Gson();

    // GET /admin/products          — list all active products
    // GET /admin/products?id=X     — get single product
    // GET /admin/products?all=true — include inactive products
    // GET /admin/products?category=X — filter by category
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String idParam       = request.getParameter("id");
        String categoryParam = request.getParameter("category");
        String allParam      = request.getParameter("all");

        try (Connection conn = DBConnection.getConnection()) {

            // Single product lookup
            if (idParam != null) {
                int id = Integer.parseInt(idParam);
                PreparedStatement ps = conn.prepareStatement(
                        "SELECT * FROM products WHERE product_id = ?"
                );
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    response.setStatus(200);
                    out.print(gson.toJson(mapProduct(rs)));
                } else {
                    response.setStatus(404);
                    out.print("{\"error\":\"Product not found\"}");
                }
                return;
            }

            // List products with optional filters
            boolean showAll = "true".equals(allParam);

            StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
            if (!showAll) sql.append(" AND is_active = true");
            if (categoryParam != null) {
                sql.append(" AND category_id = ").append(Integer.parseInt(categoryParam));
            }
            sql.append(" ORDER BY product_name");

            PreparedStatement ps = conn.prepareStatement(sql.toString());
            ResultSet rs = ps.executeQuery();

            List<Product> list = new ArrayList<>();
            while (rs.next()) list.add(mapProduct(rs));

            response.setStatus(200);
            out.print(gson.toJson(list));

        } catch (Exception e) {
            response.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // POST /admin/products — create new product
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Read JSON body
            String body = new String(request.getInputStream().readAllBytes());
            Product p = gson.fromJson(body, Product.class);

            if (!p.isValid()) {
                response.setStatus(400);
                out.print("{\"error\":\"Invalid product data\"}");
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {

                // Check category exists
                PreparedStatement catChk = conn.prepareStatement(
                        "SELECT 1 FROM product_categories WHERE category_id = ?"
                );
                catChk.setInt(1, p.getCategoryId());
                if (!catChk.executeQuery().next()) {
                    response.setStatus(400);
                    out.print("{\"error\":\"Category does not exist\"}");
                    return;
                }

                // Check for duplicate name in same category
                PreparedStatement dupChk = conn.prepareStatement(
                        "SELECT 1 FROM products WHERE LOWER(product_name) = LOWER(?) AND category_id = ?"
                );
                dupChk.setString(1, p.getProductName());
                dupChk.setInt(2, p.getCategoryId());
                if (dupChk.executeQuery().next()) {
                    response.setStatus(409);
                    out.print("{\"error\":\"Product already exists in this category\"}");
                    return;
                }

                // Insert new product
                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO products (product_name, local_name, category_id, standard_unit, is_active, date_added) " +
                                "VALUES (?, ?, ?, ?, true, NOW())",
                        Statement.RETURN_GENERATED_KEYS
                );
                ps.setString(1, p.getProductName());
                ps.setString(2, p.getLocalName());
                ps.setInt(3, p.getCategoryId());
                ps.setString(4, p.getStandardUnit());
                ps.executeUpdate();

                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) p.setProductId(keys.getInt(1));

                response.setStatus(201);
                out.print(gson.toJson(p));
            }

        } catch (Exception e) {
            response.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // PUT /admin/products?id=X — update existing product
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.setStatus(400);
            out.print("{\"error\":\"ID required\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            String body = new String(request.getInputStream().readAllBytes());
            Product p = gson.fromJson(body, Product.class);

            if (!p.isValid()) {
                response.setStatus(400);
                out.print("{\"error\":\"Invalid product data\"}");
                return;
            }

            try (Connection conn = DBConnection.getConnection()) {

                // Check for duplicate name in same category (excluding this product)
                PreparedStatement dupChk = conn.prepareStatement(
                        "SELECT 1 FROM products WHERE LOWER(product_name) = LOWER(?) " +
                                "AND category_id = ? AND product_id <> ?"
                );
                dupChk.setString(1, p.getProductName());
                dupChk.setInt(2, p.getCategoryId());
                dupChk.setInt(3, id);
                if (dupChk.executeQuery().next()) {
                    response.setStatus(409);
                    out.print("{\"error\":\"Product name already exists in this category\"}");
                    return;
                }

                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE products SET product_name = ?, local_name = ?, " +
                                "category_id = ?, standard_unit = ? WHERE product_id = ?"
                );
                ps.setString(1, p.getProductName());
                ps.setString(2, p.getLocalName());
                ps.setInt(3, p.getCategoryId());
                ps.setString(4, p.getStandardUnit());
                ps.setInt(5, id);

                int rows = ps.executeUpdate();
                if (rows == 0) {
                    response.setStatus(404);
                    out.print("{\"error\":\"Product not found\"}");
                } else {
                    p.setProductId(id);
                    response.setStatus(200);
                    out.print(gson.toJson(p));
                }
            }

        } catch (Exception e) {
            response.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // DELETE /admin/products?id=X — soft delete (preserves price history)
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.setStatus(400);
            out.print("{\"error\":\"ID required\"}");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            try (Connection conn = DBConnection.getConnection()) {
                // Soft delete — set is_active = false, keep all price history intact
                PreparedStatement ps = conn.prepareStatement(
                        "UPDATE products SET is_active = false WHERE product_id = ?"
                );
                ps.setInt(1, id);
                int rows = ps.executeUpdate();

                if (rows == 0) {
                    response.setStatus(404);
                    out.print("{\"error\":\"Product not found\"}");
                } else {
                    response.setStatus(200);
                    out.print("{\"message\":\"Product deactivated\"}");
                }
            }

        } catch (Exception e) {
            response.setStatus(500);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    // Map a ResultSet row to a Product object
    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setProductName(rs.getString("product_name"));
        p.setLocalName(rs.getString("local_name"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setStandardUnit(rs.getString("standard_unit"));
        p.setActive(rs.getBoolean("is_active"));
        p.setDateAdded(rs.getString("date_added"));
        return p;
    }
}