package database;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DB_ORA {
    // Database connection details
    private static final String JDBC_URL = "jdbc:oracle:thin:@//localhost:1521/xe";  // Using service name
    private static final String USERNAME = "system";                                     // Oracle DB username
    private static final String PASSWORD = "root";                                   // Oracle DB password

    static {
        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, USERNAME, PASSWORD);
    }
}
