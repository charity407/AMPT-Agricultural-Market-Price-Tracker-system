package com.ampt.util;

import com.ampt.db.DatabaseConfig;
import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.sql.*;
import java.util.*;

/**
 * AMPT – Member 3 (Products, Markets & Regions – Backend)
 *
 * REST endpoint: /api/dropdowns
 *
 * Returns lightweight product/market/region/category lists used to
 * populate &lt;select&gt; elements across the entire AMPT frontend:
 *
 *   – Member 4's price entry form  (products, markets dropdowns)
 *   – Member 6's JSP pages         (all four dropdown types)
 *   – Admin dashboards             (all four)
 *
 * THIS CLASS MUST BE DELIVERED BY WEEK 3 (per project task board).
 *
 * Routes:
 *   GET /api/dropdowns/products          – id + name + unit (active only)
 *   GET /api/dropdowns/products?cat={id} – filter by category
 *   GET /api/dropdowns/markets           – id + name + town (active only)
 *   GET /api/dropdowns/markets?region={id} – filter by region
 *   GET /api/dropdowns/categories        – id + name + type
 *   GET /api/dropdowns/regions           – id + name + code
 *   GET /api/dropdowns/all              – all four lists in one response
 *
 * Response format for each dropdown item is minimal to reduce payload:
 * { "id": 1, "label": "Maize (White) [90 kg bag]", ... }
 *
 * All responses are JSON.  Read-only – no writes here.
 */
public class DropdownHelper implements HttpHandler {

    private static final Gson gson = new Gson();

    // ---------------------------------------------------------------
    // Entry point – route by path segment after /api/dropdowns/
    // ---------------------------------------------------------------

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        exchange.getResponseHeaders().add("Access-Control-Allow-Origin", "*");
        exchange.getResponseHeaders().add("Access-Control-Allow-Methods",
                "GET, OPTIONS");
        exchange.getResponseHeaders().add("Access-Control-Allow-Headers",
                "Content-Type, Authorization");

        if ("OPTIONS".equalsIgnoreCase(exchange.getRequestMethod())) {
            sendResponse(exchange, 204, "");
            return;
        }

        if (!"GET".equalsIgnoreCase(exchange.getRequestMethod())) {
            sendResponse(exchange, 405, json("error", "Method not allowed"));
            return;
        }

        try {
            String path = exchange.getRequestURI().getPath();
            // Strip trailing slash if present
            if (path.endsWith("/")) path = path.substring(0, path.length() - 1);

            String segment = path.substring(path.lastIndexOf('/') + 1);

            switch (segment.toLowerCase()) {
                case "products":
                    handleProducts(exchange);
                    break;
                case "markets":
                    handleMarkets(exchange);
                    break;
                case "categories":
                    handleCategories(exchange);
                    break;
                case "regions":
                    handleRegions(exchange);
                    break;
                case "all":
                    handleAll(exchange);
                    break;
                default:
                    sendResponse(exchange, 404,
                        json("error", "Unknown dropdown type: " + segment));
            }
        } catch (Exception e) {
            System.err.println("[DropdownHelper] Error: " + e.getMessage());
            sendResponse(exchange, 500, json("error", "Internal server error"));
        }
    }

    // ---------------------------------------------------------------
    // /api/dropdowns/products[?cat={categoryId}]
    //
    // Returns list of active products.
    // Optionally filtered by categoryId for multi-step dropdowns
    // (e.g. user picks "Cereals" then sees only cereal products).
    //
    // Item shape: { id, label, unit, categoryId }
    // ---------------------------------------------------------------

    private void handleProducts(HttpExchange ex)
            throws IOException, SQLException {

        Integer catFilter = getIntParam(ex, "cat");

        StringBuilder sql = new StringBuilder(
            "SELECT p.product_id, p.product_name, p.standard_unit, " +
            "       p.category_id, c.category_name " +
            "FROM products p " +
            "JOIN product_categories c ON c.category_id = p.category_id " +
            "WHERE p.is_active = TRUE");

        if (catFilter != null) sql.append(" AND p.category_id = ?");
        sql.append(" ORDER BY c.category_name, p.product_name");

        List<Map<String, Object>> items = new ArrayList<>();
        Connection conn = DatabaseConfig.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (catFilter != null) ps.setInt(1, catFilter);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("id",           rs.getInt("product_id"));
                item.put("label",        rs.getString("product_name")
                                         + " [" + rs.getString("standard_unit") + "]");
                item.put("name",         rs.getString("product_name"));
                item.put("unit",         rs.getString("standard_unit"));
                item.put("categoryId",   rs.getInt("category_id"));
                item.put("categoryName", rs.getString("category_name"));
                items.add(item);
            }
        } finally {
            DatabaseConfig.releaseConnection(conn);
        }

        sendResponse(ex, 200, gson.toJson(items));
    }

    // ---------------------------------------------------------------
    // /api/dropdowns/markets[?region={regionId}]
    //
    // Returns list of ACTIVE markets, optionally filtered by region.
    // Used in the price entry form (Member 4) and dashboards.
    //
    // Item shape: { id, label, town, regionId, regionName }
    // ---------------------------------------------------------------

    private void handleMarkets(HttpExchange ex)
            throws IOException, SQLException {

        Integer regionFilter = getIntParam(ex, "region");

        StringBuilder sql = new StringBuilder(
            "SELECT m.market_id, m.market_name, m.town, " +
            "       m.region_id, r.region_name " +
            "FROM markets m " +
            "JOIN regions r ON r.region_id = m.region_id " +
            "WHERE UPPER(m.status) = 'ACTIVE'");

        if (regionFilter != null) sql.append(" AND m.region_id = ?");
        sql.append(" ORDER BY r.region_name, m.market_name");

        List<Map<String, Object>> items = new ArrayList<>();
        Connection conn = DatabaseConfig.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            if (regionFilter != null) ps.setInt(1, regionFilter);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("id",         rs.getInt("market_id"));
                item.put("label",      rs.getString("market_name")
                                       + " – " + rs.getString("town"));
                item.put("name",       rs.getString("market_name"));
                item.put("town",       rs.getString("town"));
                item.put("regionId",   rs.getInt("region_id"));
                item.put("regionName", rs.getString("region_name"));
                items.add(item);
            }
        } finally {
            DatabaseConfig.releaseConnection(conn);
        }

        sendResponse(ex, 200, gson.toJson(items));
    }

    // ---------------------------------------------------------------
    // /api/dropdowns/categories
    //
    // Returns all product categories (used to drive the cascading
    // category→product dropdown pair on price entry forms).
    //
    // Item shape: { id, label, type, eacCode }
    // ---------------------------------------------------------------

    private void handleCategories(HttpExchange ex)
            throws IOException, SQLException {

        String sql = "SELECT category_id, category_name, category_type, eac_code " +
                     "FROM product_categories ORDER BY category_name";

        List<Map<String, Object>> items = new ArrayList<>();
        Connection conn = DatabaseConfig.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("id",      rs.getInt("category_id"));
                item.put("label",   rs.getString("category_name"));
                item.put("name",    rs.getString("category_name"));
                item.put("type",    rs.getString("category_type"));
                item.put("eacCode", rs.getString("eac_code"));
                items.add(item);
            }
        } finally {
            DatabaseConfig.releaseConnection(conn);
        }

        sendResponse(ex, 200, gson.toJson(items));
    }

    // ---------------------------------------------------------------
    // /api/dropdowns/regions
    //
    // Returns all regions (used to drive the cascading region→market
    // dropdown pair and the regional comparison filter).
    //
    // Item shape: { id, label, code, country }
    // ---------------------------------------------------------------

    private void handleRegions(HttpExchange ex)
            throws IOException, SQLException {

        String sql = "SELECT region_id, region_name, region_code, country " +
                     "FROM regions ORDER BY region_name";

        List<Map<String, Object>> items = new ArrayList<>();
        Connection conn = DatabaseConfig.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("id",      rs.getInt("region_id"));
                item.put("label",   rs.getString("region_name")
                                    + " (" + rs.getString("region_code") + ")");
                item.put("name",    rs.getString("region_name"));
                item.put("code",    rs.getString("region_code"));
                item.put("country", rs.getString("country"));
                items.add(item);
            }
        } finally {
            DatabaseConfig.releaseConnection(conn);
        }

        sendResponse(ex, 200, gson.toJson(items));
    }

    // ---------------------------------------------------------------
    // /api/dropdowns/all
    //
    // Returns all four lists in a single HTTP round-trip.
    // Used by JSP pages (Member 6) that need all four on page load.
    //
    // Response shape:
    // {
    //   "categories": [...],
    //   "products":   [...],
    //   "regions":    [...],
    //   "markets":    [...]
    // }
    // ---------------------------------------------------------------

    private void handleAll(HttpExchange ex) throws IOException, SQLException {
        Map<String, Object> all = new LinkedHashMap<>();
        all.put("categories", queryCategories());
        all.put("products",   queryProducts(null));
        all.put("regions",    queryRegions());
        all.put("markets",    queryMarkets(null));
        sendResponse(ex, 200, gson.toJson(all));
    }

    // ---------------------------------------------------------------
    // Reusable query helpers (also called from /all endpoint)
    // ---------------------------------------------------------------

    private List<Map<String, Object>> queryCategories() throws SQLException {
        String sql = "SELECT category_id, category_name, category_type, eac_code " +
                     "FROM product_categories ORDER BY category_name";
        List<Map<String, Object>> items = new ArrayList<>();
        Connection conn = DatabaseConfig.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("id",      rs.getInt("category_id"));
                m.put("label",   rs.getString("category_name"));
                m.put("name",    rs.getString("category_name"));
                m.put("type",    rs.getString("category_type"));
                m.put("eacCode", rs.getString("eac_code"));
                items.add(m);
            }
        } finally {
            DatabaseConfig.releaseConnection(conn);
        }
        return items;
    }

    private List<Map<String, Object>> queryProducts(Integer catId)
            throws SQLException {
        String sql = "SELECT p.product_id, p.product_name, p.standard_unit, " +
                     "p.category_id, c.category_name FROM products p " +
                     "JOIN product_categories c ON c.category_id=p.category_id " +
                     "WHERE p.is_active=TRUE" +
                     (catId != null ? " AND p.category_id=?" : "") +
                     " ORDER BY c.category_name, p.product_name";
        List<Map<String, Object>> items = new ArrayList<>();
        Connection conn = DatabaseConfig.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (catId != null) ps.setInt(1, catId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("id",           rs.getInt("product_id"));
                m.put("label",        rs.getString("product_name")
                                      + " [" + rs.getString("standard_unit") + "]");
                m.put("name",         rs.getString("product_name"));
                m.put("unit",         rs.getString("standard_unit"));
                m.put("categoryId",   rs.getInt("category_id"));
                m.put("categoryName", rs.getString("category_name"));
                items.add(m);
            }
        } finally {
            DatabaseConfig.releaseConnection(conn);
        }
        return items;
    }

    private List<Map<String, Object>> queryRegions() throws SQLException {
        String sql = "SELECT region_id, region_name, region_code, country " +
                     "FROM regions ORDER BY region_name";
        List<Map<String, Object>> items = new ArrayList<>();
        Connection conn = DatabaseConfig.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("id",      rs.getInt("region_id"));
                m.put("label",   rs.getString("region_name")
                                 + " (" + rs.getString("region_code") + ")");
                m.put("name",    rs.getString("region_name"));
                m.put("code",    rs.getString("region_code"));
                m.put("country", rs.getString("country"));
                items.add(m);
            }
        } finally {
            DatabaseConfig.releaseConnection(conn);
        }
        return items;
    }

    private List<Map<String, Object>> queryMarkets(Integer regionId)
            throws SQLException {
        String sql = "SELECT m.market_id, m.market_name, m.town, " +
                     "m.region_id, r.region_name FROM markets m " +
                     "JOIN regions r ON r.region_id=m.region_id " +
                     "WHERE UPPER(m.status)='ACTIVE'" +
                     (regionId != null ? " AND m.region_id=?" : "") +
                     " ORDER BY r.region_name, m.market_name";
        List<Map<String, Object>> items = new ArrayList<>();
        Connection conn = DatabaseConfig.getConnection();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            if (regionId != null) ps.setInt(1, regionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> m = new LinkedHashMap<>();
                m.put("id",         rs.getInt("market_id"));
                m.put("label",      rs.getString("market_name")
                                    + " – " + rs.getString("town"));
                m.put("name",       rs.getString("market_name"));
                m.put("town",       rs.getString("town"));
                m.put("regionId",   rs.getInt("region_id"));
                m.put("regionName", rs.getString("region_name"));
                items.add(m);
            }
        } finally {
            DatabaseConfig.releaseConnection(conn);
        }
        return items;
    }

    // ---------------------------------------------------------------
    // Utility helpers
    // ---------------------------------------------------------------

    private Integer getIntParam(HttpExchange ex, String name) {
        String query = ex.getRequestURI().getQuery();
        if (query == null) return null;
        for (String param : query.split("&")) {
            if (param.startsWith(name + "=")) {
                try {
                    return Integer.parseInt(param.substring(name.length() + 1));
                } catch (NumberFormatException ignored) {}
            }
        }
        return null;
    }

    private String json(String key, String value) {
        return "{\"" + key + "\":\"" + value + "\"}";
    }

    private void sendResponse(HttpExchange ex, int status, String body)
            throws IOException {
        byte[] bytes = body.getBytes(StandardCharsets.UTF_8);
        ex.getResponseHeaders().set("Content-Type",
                "application/json; charset=UTF-8");
        ex.sendResponseHeaders(status, bytes.length);
        try (OutputStream os = ex.getResponseBody()) {
            os.write(bytes);
        }
    }
}
