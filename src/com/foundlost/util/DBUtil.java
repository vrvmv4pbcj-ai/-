package com.foundlost.util;

import java.io.InputStream;
import java.sql.*;
import java.util.Properties;

public class DBUtil {
    private static final String DRIVER;
    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;

    static {
        String d = "com.mysql.cj.jdbc.Driver";
        String u = "jdbc:mysql://localhost:3306/foundlost?useSSL=false&serverTimezone=Asia/Shanghai&useUnicode=true&characterEncoding=UTF-8";
        String n = "root";
        String p = "123456";

        InputStream is = null;
        try {
            ClassLoader cl = Thread.currentThread().getContextClassLoader();
            if (cl != null) {
                is = cl.getResourceAsStream("db.properties");
            }
            if (is == null) {
                is = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            }
            if (is != null) {
                Properties props = new Properties();
                props.load(is);
                is.close();
                d = props.getProperty("jdbc.driver", d);
                u = props.getProperty("jdbc.url", u);
                n = props.getProperty("jdbc.user", n);
                p = props.getProperty("jdbc.password", p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        DRIVER = d;
        URL = u;
        USER = n;
        PASSWORD = p;

        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL driver not found: " + DRIVER, e);
        }
    }

    public static Connection getConnection() {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public static void close(Connection conn, Statement stmt, ResultSet rs) {
        try { if (rs   != null) rs.close();   } catch (SQLException ignored) {}
        try { if (stmt != null) stmt.close(); } catch (SQLException ignored) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
}