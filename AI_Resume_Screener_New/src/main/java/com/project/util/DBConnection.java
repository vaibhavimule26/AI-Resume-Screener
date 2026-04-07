package com.project.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection connection;

    public static Connection getConnection() {

        try {
            if (connection == null || connection.isClosed()) {

                // Load MySQL JDBC Driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Database details
                String url = "jdbc:mysql://localhost:3306/ai_resume_screener"
                        + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
                String username = "root";
                String password = "Vaibhavi@1722";

                // Create connection
                connection = DriverManager.getConnection(url, username, password);

                System.out.println("✅ Database connected successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return connection;
    }
}
