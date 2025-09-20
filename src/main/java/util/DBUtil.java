package util;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 * 데이터베이스 연결을 관리하는 유틸리티 클래스
 */
public class DBUtil {
    private static Properties props = new Properties();
    private static String driver;
    private static String url;
    private static String username;
    private static String password;
    
    static {
        try {
            // db.properties 파일 로드
            InputStream is = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            if (is == null) {
                throw new RuntimeException("db.properties 파일을 찾을 수 없습니다.");
            }
            props.load(is);
            
            driver = props.getProperty("db.driver");
            url = props.getProperty("db.url");
            username = props.getProperty("db.username");
            password = props.getProperty("db.password");
            
            // JDBC 드라이버 로드
            Class.forName(driver);
            
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("JDBC 드라이버를 찾을 수 없습니다.", e);
        } catch (IOException e) {
            throw new RuntimeException("db.properties 파일을 읽을 수 없습니다.", e);
        }
    }
    
    /**
     * 데이터베이스 연결을 반환합니다.
     * @return Connection 객체
     * @throws SQLException 데이터베이스 연결 오류 시
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, username, password);
    }
    
    /**
     * 데이터베이스 연결을 닫습니다.
     * @param conn 닫을 Connection 객체
     */
    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
