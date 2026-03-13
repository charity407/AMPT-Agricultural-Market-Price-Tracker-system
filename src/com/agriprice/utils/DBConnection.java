package com.agriprice.utils;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

/**
 * DBConnection.java
 * Author  : Member 4 (PM)
 * Purpose : Single shared database connection class.
 *           Used by ALL Servlets in the project.
 *
 * Usage in any Servlet:
 *   try (Connection conn = DBConnection.getConnection()) {
 *       // your JDBC code here
 *   }
 *
 * DO NOT modify this file without telling the whole team.
 */
public class DBConnection {

    private static String URL;
    private static String USERNAME;
    private static String PASSWORD;

    // Runs once when the class is first loaded
    static {
        try {
            Properties props = new Properties();

            // Load from classpath (src/com/agriprice/utils/db.properties)
            InputStream in = DBConnection.class
                .getClassLoader()
                .getResourceAsStream("com/agriprice/utils/db.properties");

            if (in == null) {
                throw new RuntimeException(
                    "ERROR: db.properties not found! " +
                    "Place it at: src/com/agriprice/utils/db.properties"
                );
            }

            props.load(in);
            Class.forName(props.getProperty("db.driver"));
            URL      = props.getProperty("db.url");
            USERNAME = props.getProperty("db.username");
            PASSWORD = props.getProperty("db.password");

            System.out.println("[DBConnection] Loaded OK. URL: " + URL);

        } catch (Exception e) {
            System.err.println("[DBConnection] INIT FAILED: " + e.getMessage());
            throw new RuntimeException("DBConnection failed to initialise.", e);
        }
    }

    /**
     * Returns a live JDBC connection to the database.
     * Always use try-with-resources so it closes automatically:
     *
     *   try (Connection conn = DBConnection.getConnection()) { ... }
     */
    public static Connection getConnection() throws Exception {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }
}
