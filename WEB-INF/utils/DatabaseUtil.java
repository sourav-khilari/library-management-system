package utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;
import java.io.InputStream;
import java.io.IOException;

public class DatabaseUtil {
    private static String jdbcUrl;
    private static String dbUsername;
    private static String dbPassword;

    static {
        try (InputStream input = DatabaseUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
            Properties prop = new Properties();
            if (input == null) {
                System.out.println("Sorry, unable to find db.properties");
                //return;
            }
            // Load a properties file from class path
            prop.load(input);
            jdbcUrl = prop.getProperty("jdbcUrl");
            dbUsername = prop.getProperty("dbUsername");
            dbPassword = prop.getProperty("dbPassword");
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(jdbcUrl, dbUsername, dbPassword);
    }
}
