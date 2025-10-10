package poly.com.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import poly.com.model.Newsletter;
import poly.com.utils.JDBC;

public class NewsletterDAO extends Asm<Newsletter, String> {

    @Override
    public void insert(Newsletter e) {
        final String sql = "INSERT INTO dbo.NEWSLETTERS (Email, Enabled) VALUES (?,?)";
        try {
            JDBC.executeUpdate(sql, e.getEmail(), e.getEnabled());
        } catch (SQLException ex) {
            throw new RuntimeException("Insert NEWSLETTERS failed", ex);
        }
    }

    @Override
    public void update(Newsletter e) {
        final String sql = "UPDATE dbo.NEWSLETTERS SET Enabled=? WHERE Email=?";
        try {
            JDBC.executeUpdate(sql, e.getEnabled(), e.getEmail());
        } catch (SQLException ex) {
            throw new RuntimeException("Update NEWSLETTERS failed (Email=" + e.getEmail() + ")", ex);
        }
    }

    @Override
    public void delete(String email) {
        final String sql = "DELETE FROM dbo.NEWSLETTERS WHERE Email=?";
        try {
            JDBC.executeUpdate(sql, email);
        } catch (SQLException ex) {
            throw new RuntimeException("Delete NEWSLETTERS failed (Email=" + email + ")", ex);
        }
    }

    @Override
    public Newsletter selectById(String email) {
        final String sql = "SELECT * FROM dbo.NEWSLETTERS WHERE Email=?";
        List<Newsletter> list = selectBySql(sql, email);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<Newsletter> selectAll() {
        final String sql = "SELECT * FROM dbo.NEWSLETTERS ORDER BY Email ASC";
        return selectBySql(sql);
    }

    @Override
    public List<Newsletter> selectBySql(String sql, Object... args) {
        List<Newsletter> list = new ArrayList<>();
        try (var rs = JDBC.executeQuery(sql, args)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception ex) {
            throw new RuntimeException("Query NEWSLETTERS failed", ex);
        }
        return list;
    }

    /** Đếm tổng số subscriber */
    public int countAll() {
        final String sql = "SELECT COUNT(*) FROM dbo.NEWSLETTERS";
        try (var rs = JDBC.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception ex) {
            throw new RuntimeException("Count NEWSLETTERS failed", ex);
        }
    }

    /** Tiện ích: đăng ký (bật Enabled=1, có thì cập nhật, chưa có thì chèn) */
    public void subscribe(String email) {
        // Sử dụng MERGE (nếu SQL Server 2008+). Hoặc 2 bước: select rồi insert/update.
        final String sql = """
            MERGE dbo.NEWSLETTERS AS t
            USING (SELECT ? AS Email) AS s
               ON t.Email = s.Email
            WHEN MATCHED THEN UPDATE SET Enabled = 1
            WHEN NOT MATCHED THEN INSERT (Email, Enabled) VALUES (s.Email, 1);
            """;
        try {
            JDBC.executeUpdate(sql, email);
        } catch (SQLException ex) {
            throw new RuntimeException("Subscribe NEWSLETTERS failed", ex);
        }
    }

    private Newsletter mapRow(ResultSet rs) throws SQLException {
        Newsletter n = new Newsletter();
        n.setEmail(rs.getString("Email"));
        n.setEnabled(rs.getObject("Enabled") != null ? rs.getBoolean("Enabled") : null);
        return n;
    }
}
