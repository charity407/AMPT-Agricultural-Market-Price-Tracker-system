package com.agriprice.servlets;

import com.agriprice.models.Region;
import com.agriprice.utils.DatabaseConfig;
import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RegionServlet implements HttpHandler {

    private final Gson gson = new Gson();

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
            switch (method) {
                case "GET":    handleGet(exchange, id, query);  break;
                case "POST":   handlePost(exchange);             break;
                case "PUT":    handlePut(exchange, id);          break;
                case "DELETE": handleDelete(exchange, id);       break;
                default:       send(exchange, 405, "{\"error\":\"Method not allowed\"}");
            }
        } catch (Exception e) {
            send(exchange, 500, "{\"error\":\"" + e.getMessage() + "\"}");
        }
    }

    private void handleGet(HttpExchange ex, Integer id, String query) throws Exception {
        Connection conn = DatabaseConfig.getConnection();
        if (id != null) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM regions WHERE region_id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) send(ex, 200, gson.toJson(mapRegion(rs)));
            else           send(ex, 404, "{\"error\":\"Region not found\"}");
            return;
        }
        String countryFilter = null;
        if (query != null) {
            for (String param : query.split("&")) {
                if (param.startsWith("country=")) countryFilter = param.substring(8);
            }
        }
        String sql = "SELECT * FROM regions" + (countryFilter != null ? " WHERE country=?" : "") + " ORDER BY region_name";
        PreparedStatement ps = conn.prepareStatement(sql);
        if (countryFilter != null) ps.setString(1, countryFilter);
        ResultSet rs = ps.executeQuery();
        List<Region> list = new ArrayList<>();
        while (rs.next()) list.add(mapRegion(rs));
        send(ex, 200, gson.toJson(list));
    }

    private void handlePost(HttpExchange ex) throws Exception {
        Region r = gson.fromJson(body(ex), Region.class);
        if (!r.isValid()) { send(ex, 400, "{\"error\":\"Invalid region data\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();

        PreparedStatement dupName = conn.prepareStatement(
            "SELECT 1 FROM regions WHERE LOWER(region_name)=LOWER(?) AND country=?");
        dupName.setString(1, r.getRegionName()); dupName.setString(2, r.getCountry());
        if (dupName.executeQuery().next()) { send(ex, 409, "{\"error\":\"Region name already exists for this country\"}"); return; }

        PreparedStatement dupCode = conn.prepareStatement("SELECT 1 FROM regions WHERE region_code=?");
        dupCode.setString(1, r.getRegionCode());
        if (dupCode.executeQuery().next()) { send(ex, 409, "{\"error\":\"Region code already in use\"}"); return; }

        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO regions(region_name,country,region_code) VALUES(?,?,?)",
            Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, r.getRegionName());
        ps.setString(2, r.getCountry() != null ? r.getCountry() : "KEN");
        ps.setString(3, r.getRegionCode());
        ps.executeUpdate();
        ResultSet keys = ps.getGeneratedKeys();
        if (keys.next()) r.setRegionId(keys.getInt(1));
        send(ex, 201, gson.toJson(r));
    }

    private void handlePut(HttpExchange ex, Integer id) throws Exception {
        if (id == null) { send(ex, 400, "{\"error\":\"ID required\"}"); return; }
        Region r = gson.fromJson(body(ex), Region.class);
        if (!r.isValid()) { send(ex, 400, "{\"error\":\"Invalid region data\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();

        PreparedStatement dupCode = conn.prepareStatement(
            "SELECT 1 FROM regions WHERE region_code=? AND region_id<>?");
        dupCode.setString(1, r.getRegionCode()); dupCode.setInt(2, id);
        if (dupCode.executeQuery().next()) { send(ex, 409, "{\"error\":\"Region code already in use\"}"); return; }

        PreparedStatement ps = conn.prepareStatement(
            "UPDATE regions SET region_name=?,country=?,region_code=? WHERE region_id=?");
        ps.setString(1, r.getRegionName());
        ps.setString(2, r.getCountry());
        ps.setString(3, r.getRegionCode());
        ps.setInt(4, id);
        int rows = ps.executeUpdate();
        if (rows == 0) send(ex, 404, "{\"error\":\"Region not found\"}");
        else { r.setRegionId(id); send(ex, 200, gson.toJson(r)); }
    }

    private void handleDelete(HttpExchange ex, Integer id) throws Exception {
        if (id == null) { send(ex, 400, "{\"error\":\"ID required\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();
        PreparedStatement chk = conn.prepareStatement("SELECT 1 FROM markets WHERE region_id=? AND status='ACTIVE' LIMIT 1");
        chk.setInt(1, id);
        if (chk.executeQuery().next()) { send(ex, 409, "{\"error\":\"Cannot delete: active markets exist in this region\"}"); return; }
        PreparedStatement ps = conn.prepareStatement("DELETE FROM regions WHERE region_id=?");
        ps.setInt(1, id);
        int rows = ps.executeUpdate();
        if (rows == 0) send(ex, 404, "{\"error\":\"Region not found\"}");
        else send(ex, 200, "{\"message\":\"Region deleted\"}");
    }

    private Region mapRegion(ResultSet rs) throws SQLException {
        Region r = new Region();
        r.setRegionId(rs.getInt("region_id"));
        r.setRegionName(rs.getString("region_name"));
        r.setCountry(rs.getString("country"));
        r.setRegionCode(rs.getString("region_code"));
        return r;
    }

    private String body(HttpExchange ex) throws IOException { return new String(ex.getRequestBody().readAllBytes()); }
    private Integer parseId(String s) { try { return Integer.parseInt(s); } catch (Exception e) { return null; } }
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
