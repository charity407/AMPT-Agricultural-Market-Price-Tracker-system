package com.agriprice.servlets;

import com.agriprice.models.Market;
import com.agriprice.utils.DatabaseConfig;
import com.google.gson.Gson;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MarketServlet implements HttpHandler {

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

        // Single market by ID
        if (id != null) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM markets WHERE market_id=?");
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) send(ex, 200, gson.toJson(mapMarket(rs)));
            else           send(ex, 404, "{\"error\":\"Market not found\"}");
            return;
        }

        // Parse query params
        // Supports: ?regionId=1  ?region=1  ?status=INACTIVE
        String regionFilter = null;
        String statusFilter = "ACTIVE"; // default — only active markets

        if (query != null) {
            for (String param : query.split("&")) {
                if (param.startsWith("regionId=")) regionFilter = param.substring(9);
                if (param.startsWith("region="))   regionFilter = param.substring(7);
                if (param.startsWith("status="))   statusFilter = param.substring(7).toUpperCase();
            }
        }

        StringBuilder sql = new StringBuilder("SELECT * FROM markets WHERE status=?");
        if (regionFilter != null) {
            sql.append(" AND region_id=").append(Integer.parseInt(regionFilter));
        }
        sql.append(" ORDER BY market_name");

        PreparedStatement ps = conn.prepareStatement(sql.toString());
        ps.setString(1, statusFilter);
        ResultSet rs = ps.executeQuery();
        List<Market> list = new ArrayList<>();
        while (rs.next()) list.add(mapMarket(rs));
        send(ex, 200, gson.toJson(list));
    }

    private void handlePost(HttpExchange ex) throws Exception {
        Market m = gson.fromJson(body(ex), Market.class);
        if (!m.isValid()) { send(ex, 400, "{\"error\":\"Invalid market data\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();

        // Verify region exists
        PreparedStatement regChk = conn.prepareStatement("SELECT 1 FROM regions WHERE region_id=?");
        regChk.setInt(1, m.getRegionId());
        if (!regChk.executeQuery().next()) {
            send(ex, 400, "{\"error\":\"Region does not exist\"}"); return;
        }

        // Unique name per region
        PreparedStatement dupChk = conn.prepareStatement(
            "SELECT 1 FROM markets WHERE LOWER(market_name)=LOWER(?) AND region_id=?");
        dupChk.setString(1, m.getMarketName()); dupChk.setInt(2, m.getRegionId());
        if (dupChk.executeQuery().next()) {
            send(ex, 409, "{\"error\":\"Market name already exists in this region\"}"); return;
        }

        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO markets(market_name,physical_address,town,country,latitude,longitude,operating_days,operating_hours,status,date_registered,region_id) VALUES(?,?,?,?,?,?,?,?,?,NOW(),?)",
            Statement.RETURN_GENERATED_KEYS);
        ps.setString(1, m.getMarketName());
        ps.setString(2, m.getPhysicalAddress());
        ps.setString(3, m.getTown());
        ps.setString(4, m.getCountry() != null ? m.getCountry() : "KEN");
        ps.setDouble(5, m.getLatitude());
        ps.setDouble(6, m.getLongitude());
        ps.setString(7, m.getOperatingDays());
        ps.setString(8, m.getOperatingHours());
        ps.setString(9, m.getStatus() != null ? m.getStatus() : "ACTIVE");
        ps.setInt(10, m.getRegionId());
        ps.executeUpdate();
        ResultSet keys = ps.getGeneratedKeys();
        if (keys.next()) m.setMarketId(keys.getInt(1));
        send(ex, 201, gson.toJson(m));
    }

    private void handlePut(HttpExchange ex, Integer id) throws Exception {
        if (id == null) { send(ex, 400, "{\"error\":\"ID required\"}"); return; }
        Market m = gson.fromJson(body(ex), Market.class);
        if (!m.isValid()) { send(ex, 400, "{\"error\":\"Invalid market data\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();

        PreparedStatement dupChk = conn.prepareStatement(
            "SELECT 1 FROM markets WHERE LOWER(market_name)=LOWER(?) AND region_id=? AND market_id<>?");
        dupChk.setString(1, m.getMarketName());
        dupChk.setInt(2, m.getRegionId());
        dupChk.setInt(3, id);
        if (dupChk.executeQuery().next()) {
            send(ex, 409, "{\"error\":\"Market name already exists in this region\"}"); return;
        }

        PreparedStatement ps = conn.prepareStatement(
            "UPDATE markets SET market_name=?,physical_address=?,town=?,operating_days=?,operating_hours=?,status=?,region_id=? WHERE market_id=?");
        ps.setString(1, m.getMarketName());
        ps.setString(2, m.getPhysicalAddress());
        ps.setString(3, m.getTown());
        ps.setString(4, m.getOperatingDays());
        ps.setString(5, m.getOperatingHours());
        ps.setString(6, m.getStatus());
        ps.setInt(7, m.getRegionId());
        ps.setInt(8, id);
        int rows = ps.executeUpdate();
        if (rows == 0) send(ex, 404, "{\"error\":\"Market not found\"}");
        else { m.setMarketId(id); send(ex, 200, gson.toJson(m)); }
    }

    private void handleDelete(HttpExchange ex, Integer id) throws Exception {
        if (id == null) { send(ex, 400, "{\"error\":\"ID required\"}"); return; }
        Connection conn = DatabaseConfig.getConnection();
        // Soft delete — preserve price history
        PreparedStatement ps = conn.prepareStatement(
            "UPDATE markets SET status='INACTIVE' WHERE market_id=?");
        ps.setInt(1, id);
        int rows = ps.executeUpdate();
        if (rows == 0) send(ex, 404, "{\"error\":\"Market not found\"}");
        else send(ex, 200, "{\"message\":\"Market deactivated\"}");
    }

    private Market mapMarket(ResultSet rs) throws SQLException {
        Market m = new Market();
        m.setMarketId(rs.getInt("market_id"));
        m.setMarketName(rs.getString("market_name"));
        m.setPhysicalAddress(rs.getString("physical_address"));
        m.setTown(rs.getString("town"));
        m.setCountry(rs.getString("country"));
        m.setLatitude(rs.getDouble("latitude"));
        m.setLongitude(rs.getDouble("longitude"));
        m.setOperatingDays(rs.getString("operating_days"));
        m.setOperatingHours(rs.getString("operating_hours"));
        m.setStatus(rs.getString("status"));
        m.setDateRegistered(rs.getString("date_registered"));
        m.setRegionId(rs.getInt("region_id"));
        return m;
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
