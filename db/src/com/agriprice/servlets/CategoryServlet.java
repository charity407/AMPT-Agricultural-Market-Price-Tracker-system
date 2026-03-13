package com.agriprice.servlets;

import com.agriprice.models.Category;
import com.agriprice.utils.DatabaseConfig;
import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.*;
import java.net.URI;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryServlet implements HttpHandler {

    private final Gson gson = new Gson();

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        addCors(exchange);
        if ("OPTIONS".equals(exchange.getRequestMethod())) { exchange.sendResponseHeaders(204, -1); return; }
        String method = exchange.getRequestMethod();
        String path   = exchange.getRequestURI().getPath(); // /api/categories or /api/categories/3
        String[] parts = path.split("/");
        Integer id = parts.length >= 4 ? parseId(parts[3]) : null;

        try {
            switch (method) {
                case "GET":    handleGet(exchange, id);    break;
                case "POST":   handlePost(exchange);       break;
                case "PUT":    handlePut(exchange, id);    break;
                case "DELETE": handleDelete(exchange, id); break;
                default:       send(exchange, 405, "{\"error\":\"Method not allowed\"}");
            }
        } catch (Exception e) {
            send(exchange, 500, "{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private void handleGet(HttpExchange ex, Integer id) throws Exception {
        Connection conn = DatabaseConfig.getConnection();
        if (id != null) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM product_categories WHERE category_id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) send(ex, 200, gson.toJson(mapCategory(rs)));
            else           send(ex, 404, "{\"error\":\"Category not found\"}");
        } else {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM product_categories ORDER BY category_name");
            ResultSet rs = ps.executeQuery();
            List<Category> list = new ArrayList<>();
            while (rs.next()) list.add(mapCategory(rs));
            send(ex, 200, gson.toJson(list));
        }
    }

    private void handlePost(HttpExchange ex) throws Exception {
        Category cat = gson.fromJson(body(ex), Category.class);
        if (!cat.isValid()) { send(ex, 400, "{\"error\":\"Invalid category data\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();
        // duplicate check
        PreparedStatement chk = conn.prepareStatement("SELECT 1 FROM product_categories WHERE LOWER(category_name)=LOWER(?)");
        chk.setString(1, cat.getCategoryName());
        if (chk.executeQuery().next()) { send(ex, 409, "{\"error\":\"Category name already exists\"}"); return; }

        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO product_categories(category_name,category_type,eac_code,description) VALUES(?,?,?,?)",
            Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, cat.getCategoryName());
        ps.setString(2, cat.getCategoryType().toUpperCase());
        ps.setString(3, cat.getEacCode());
        ps.setString(4, cat.getDescription());
        ps.executeUpdate();
        ResultSet keys = ps.getGeneratedKeys();
        if (keys.next()) cat.setCategoryId(keys.getInt(1));
        send(ex, 201, gson.toJson(cat));
    }

    private void handlePut(HttpExchange ex, Integer id) throws Exception {
        if (id == null) { send(ex, 400, "{\"error\":\"ID required\"}"); return; }
        Category cat = gson.fromJson(body(ex), Category.class);
        if (!cat.isValid()) { send(ex, 400, "{\"error\":\"Invalid category data\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();
        PreparedStatement chk = conn.prepareStatement(
            "SELECT 1 FROM product_categories WHERE LOWER(category_name)=LOWER(?) AND category_id<>?");
        chk.setString(1, cat.getCategoryName()); chk.setInt(2, id);
        if (chk.executeQuery().next()) { send(ex, 409, "{\"error\":\"Category name already exists\"}"); return; }

        PreparedStatement ps = conn.prepareStatement(
            "UPDATE product_categories SET category_name=?,category_type=?,eac_code=?,description=? WHERE category_id=?");
        ps.setString(1, cat.getCategoryName());
        ps.setString(2, cat.getCategoryType().toUpperCase());
        ps.setString(3, cat.getEacCode());
        ps.setString(4, cat.getDescription());
        ps.setInt(5, id);
        int rows = ps.executeUpdate();
        if (rows == 0) send(ex, 404, "{\"error\":\"Category not found\"}");
        else { cat.setCategoryId(id); send(ex, 200, gson.toJson(cat)); }
    }

    private void handleDelete(HttpExchange ex, Integer id) throws Exception {
        if (id == null) { send(ex, 400, "{\"error\":\"ID required\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();
        PreparedStatement chk = conn.prepareStatement("SELECT 1 FROM products WHERE category_id=? AND is_active=true LIMIT 1");
        chk.setInt(1, id);
        if (chk.executeQuery().next()) { send(ex, 409, "{\"error\":\"Cannot delete: products exist in this category\"}"); return; }
        PreparedStatement ps = conn.prepareStatement("DELETE FROM product_categories WHERE category_id=?");
        ps.setInt(1, id);
        int rows = ps.executeUpdate();
        if (rows == 0) send(ex, 404, "{\"error\":\"Category not found\"}");
        else send(ex, 200, "{\"message\":\"Category deleted\"}");
    }

    private Category mapCategory(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryName(rs.getString("category_name"));
        c.setCategoryType(rs.getString("category_type"));
        c.setEacCode(rs.getString("eac_code"));
        c.setDescription(rs.getString("description"));
        return c;
    }

    private String body(HttpExchange ex) throws IOException {
        return new String(ex.getRequestBody().readAllBytes());
    }

    private Integer parseId(String s) {
        try { return Integer.parseInt(s); } catch (Exception e) { return null; }
    }

    private void addCors(HttpExchange ex) {
        ex.getResponseHeaders().add("Access-Control-Allow-Origin", "*");
        ex.getResponseHeaders().add("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
        ex.getResponseHeaders().add("Access-Control-Allow-Headers", "Content-Type");
    }

    private void send(HttpExchange ex, int code, String json) throws IOException {
        ex.getResponseHeaders().add("Content-Type", "application/json");
        byte[] bytes = json.getBytes();
        ex.sendResponseHeaders(code, bytes.length);
        ex.getResponseBody().write(bytes);
        ex.getResponseBody().close();
    }
}
