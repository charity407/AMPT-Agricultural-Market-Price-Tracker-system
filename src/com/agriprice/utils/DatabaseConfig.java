package com.agriprice.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConfig {
    // Replace these with the exact details from your Neon dashboard
    private static final String URL = "jdbc:postgresql://ep-bold-waterfall-anu0vnir-pooler.c-6.us-east-1.aws.neon.tech/neondb?sslmode=require";
    private static final String USER = "neondb_owner";
    private static final String PASSWORD = "npg_sNnu9Zm8CoJz";

    public static void releaseConnection(Connection conn) {
    try {
        if (conn != null && !conn.isClosed()) {
            conn.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
}
    public static Connection getConnection() throws SQLException {
        try {
            // Ensure the PostgreSQL Driver is loaded
            Class.forName("org.postgresql.Driver");
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL Driver not found. Add the JAR to your lib folder!", e);
        }
    }
}
