package poly.com.utils;

import java.sql.*;

public class JDBC {
    private static final String DRIVER = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    private static final String URL =
        "jdbc:sqlserver://localhost:1433;"
      + "databaseName=ABCNewsDB;"
      + "encrypt=true;trustServerCertificate=true;"; // dev: chấp nhận cert self-signed
    private static final String USER = "tananh";
    private static final String PASS = "tananh123";

    static {
        try { Class.forName(DRIVER); }
        catch (ClassNotFoundException e) { throw new RuntimeException(e); }
    }

    /** Mở kết nối */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASS);
    }

    /** C/U/D: tự đóng tài nguyên */
    public static int executeUpdate(String sql, Object... params) throws SQLException {
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) ps.setObject(i + 1, params[i]);
            return ps.executeUpdate();
        }
    }

    /**
     * Query: KHÔNG đóng ở đây vì còn dùng ResultSet.
     * Sau khi đọc xong phải gọi JDBC.close(rs) để đóng rs + stmt + conn.
     */
    public static ResultSet executeQuery(String sql, Object... params) throws SQLException {
        Connection con = getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        for (int i = 0; i < params.length; i++) ps.setObject(i + 1, params[i]);
        return ps.executeQuery();
    }

    /** Đóng ResultSet + Statement + Connection lấy từ ResultSet */
    public static void close(ResultSet rs) {
        if (rs == null) return;
        try {
            Statement st = rs.getStatement();
            Connection con = (st != null) ? st.getConnection() : null;
            try { rs.close(); } catch (Exception ignore) {}
            try { if (st != null) st.close(); } catch (Exception ignore) {}
            try { if (con != null) con.close(); } catch (Exception ignore) {}
        } catch (Exception ignore) {}
    }
}
