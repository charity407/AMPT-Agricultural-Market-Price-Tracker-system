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
    public void handle(HttpExchange exchange) throws IOException {
        addCors(exchange);
        if ("OPTIONS".equals(exchange.getRequestMethod())) { exchange.sendResponseHeaders(204, -1); return; }
        String method = exchange.getRequestMethod();
        String path   = exchange.getRequestURI().getPath();
        String query  = exchange.getRequestURI().getQuery();
        String[] parts = path.split("/");
        Integer id = parts.length >= 4 ? parseId(parts[3]) : null;

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

    private void handleGet(HttpExchange ex, Integer id, String query) throws Exception {
        Connection conn = DatabaseConfig.getConnection();

        // Single product by ID
        if (id != null) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE product_id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) send(ex, 200, gson.toJson(mapProduct(rs)));
            else           send(ex, 404, "{\"error\":\"Product not found\"}");
            return;
        }

        // Parse query params
        // Supports: ?categoryId=2  ?category=2  ?all=true
        String categoryFilter = null;
        boolean showAll = false;

        if (query != null) {
            for (String param : query.split("&")) {
                if (param.startsWith("categoryId=")) categoryFilter = param.substring(11);
                if (param.startsWith("category="))   categoryFilter = param.substring(9);
                if (param.equals("all=true"))         showAll = true;
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

        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
        if (!showAll) sql.append(" AND is_active=true");
        if (categoryFilter != null) {
            sql.append(" AND category_id=").append(Integer.parseInt(categoryFilter));
        }
        sql.append(" ORDER BY product_name");

        ResultSet rs = conn.prepareStatement(sql.toString()).executeQuery();
        List<Product> list = new ArrayList<>();
        while (rs.next()) list.add(mapProduct(rs));
        send(ex, 200, gson.toJson(list));
    }

    private void handlePost(HttpExchange ex) throws Exception {
        Product p = gson.fromJson(body(ex), Product.class);
        if (!p.isValid()) { send(ex, 400, "{\"error\":\"Invalid product data\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();

        // Verify category exists
        PreparedStatement catChk = conn.prepareStatement(
            "SELECT 1 FROM product_categories WHERE category_id=?");
        catChk.setInt(1, p.getCategoryId());
        if (!catChk.executeQuery().next()) {
            send(ex, 400, "{\"error\":\"Category does not exist\"}"); return;
        }

        // No duplicate name within same category
        PreparedStatement dupChk = conn.prepareStatement(
            "SELECT 1 FROM products WHERE LOWER(product_name)=LOWER(?) AND category_id=?");
        dupChk.setString(1, p.getProductName()); dupChk.setInt(2, p.getCategoryId());
        if (dupChk.executeQuery().next()) {
            send(ex, 409, "{\"error\":\"Product already exists in this category\"}"); return;
        }

        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO products(product_name,local_name,category_id,standard_unit,is_active,date_added) VALUES(?,?,?,?,true,NOW())",
            Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, p.getProductName());
        ps.setString(2, p.getLocalName());
        ps.setInt(3, p.getCategoryId());
        ps.setString(4, p.getStandardUnit());
        ps.executeUpdate();
        ResultSet keys = ps.getGeneratedKeys();
        if (keys.next()) p.setProductId(keys.getInt(1));
        send(ex, 201, gson.toJson(p));
    }

    private void handlePut(HttpExchange ex, Integer id) throws Exception {
        if (id == null) { send(ex, 400, "{\"error\":\"ID required\"}"); return; }
        Product p = gson.fromJson(body(ex), Product.class);
        if (!p.isValid()) { send(ex, 400, "{\"error\":\"Invalid product data\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();

        PreparedStatement dupChk = conn.prepareStatement(
            "SELECT 1 FROM products WHERE LOWER(product_name)=LOWER(?) AND category_id=? AND product_id<>?");
        dupChk.setString(1, p.getProductName());
        dupChk.setInt(2, p.getCategoryId());
        dupChk.setInt(3, id);
        if (dupChk.executeQuery().next()) {
            send(ex, 409, "{\"error\":\"Product name already exists in this category\"}"); return;
        }

        PreparedStatement ps = conn.prepareStatement(
            "UPDATE products SET product_name=?,local_name=?,category_id=?,standard_unit=? WHERE product_id=?");
        ps.setString(1, p.getProductName());
        ps.setString(2, p.getLocalName());
        ps.setInt(3, p.getCategoryId());
        ps.setString(4, p.getStandardUnit());
        ps.setInt(5, id);
        int rows = ps.executeUpdate();
        if (rows == 0) send(ex, 404, "{\"error\":\"Product not found\"}");
        else { p.setProductId(id); send(ex, 200, gson.toJson(p)); }
    }

    private void handleDelete(HttpExchange ex, Integer id) throws Exception {
        if (id == null) { send(ex, 400, "{\"error\":\"ID required\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();
        // Soft delete — preserve price history (DR-004)
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE products SET is_active=false WHERE product_id=?");
        ps.setInt(1, id);
        int rows = ps.executeUpdate();
        if (rows == 0) send(ex, 404, "{\"error\":\"Product not found\"}");
        else send(ex, 200, "{\"message\":\"Product deactivated\"}");
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