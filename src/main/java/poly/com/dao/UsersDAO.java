package poly.com.dao;

import poly.com.model.Users;
import poly.com.utils.JDBC;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsersDAO extends Asm<Users, String> {

    // DB của bạn dùng PK: Id_Author
    private static final String COL_ID = "Id_Author";

    // ---------- CRUD ----------
    @Override
    public void insert(Users e) {
        final String sql =
            "INSERT INTO dbo.USERS (Id_Author, [Password], Fullname, Birthday, Gender, Mobile, Email, [Role]) " +
            "VALUES (?,?,?,?,?,?,?,?)";
        try (Connection con = JDBC.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            set(ps,
                e.getId(), // alias của idAuthor
                e.getPassword(),
                e.getFullname(),
                e.getBirthday() == null ? null : new java.sql.Date(e.getBirthday().getTime()),
                e.getGender(),
                e.getMobile(),
                e.getEmail(),
                e.getRole()
            );
            ps.executeUpdate();
        } catch (SQLException ex) {
            throw new RuntimeException("Insert USERS failed (Id_Author=" + e.getId() + ")", ex);
        }
    }

    @Override
    public void update(Users e) {
        final String sql =
            "UPDATE dbo.USERS SET [Password]=?, Fullname=?, Birthday=?, Gender=?, Mobile=?, Email=?, [Role]=? " +
            "WHERE " + COL_ID + "=?";
        try (Connection con = JDBC.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            set(ps,
                e.getPassword(),
                e.getFullname(),
                e.getBirthday() == null ? null : new java.sql.Date(e.getBirthday().getTime()),
                e.getGender(),
                e.getMobile(),
                e.getEmail(),
                e.getRole(),
                e.getId()
            );
            ps.executeUpdate();
        } catch (SQLException ex) {
            throw new RuntimeException("Update USERS failed (Id_Author=" + e.getId() + ")", ex);
        }
    }

    @Override
    public void delete(String idAuthor) {
        final String sql = "DELETE FROM dbo.USERS WHERE " + COL_ID + "=?";
        try (Connection con = JDBC.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            set(ps, idAuthor);
            ps.executeUpdate();
        } catch (SQLException ex) {
            throw new RuntimeException("Delete USERS failed (Id_Author=" + idAuthor + ")", ex);
        }
    }

    // ---------- SELECT ----------
    @Override
    public List<Users> selectAll() {
        return selectBySql("SELECT * FROM dbo.USERS ORDER BY Fullname ASC");
    }

    @Override
    public Users selectById(String idAuthor) {
        List<Users> list = selectBySql("SELECT * FROM dbo.USERS WHERE " + COL_ID + "=?", idAuthor);
        return list.isEmpty() ? null : list.get(0);
    }

    /** Đăng nhập: Id_Author + Password */
    public Users login(String idAuthor, String password) {
        List<Users> list = selectBySql(
            "SELECT * FROM dbo.USERS WHERE " + COL_ID + "=? AND [Password]=?",
            idAuthor, password
        );
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<Users> selectBySql(String sql, Object... args) {
        List<Users> list = new ArrayList<>();
        try (Connection con = JDBC.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            set(ps, args);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Query USERS failed", ex);
        }
        return list;
    }

    // ---------- Helpers ----------
    public long countAll() {
        try (var rs = JDBC.executeQuery("SELECT COUNT(*) FROM dbo.USERS")) {
            return rs.next() ? rs.getLong(1) : 0L;
        } catch (SQLException e) {
            throw new RuntimeException("COUNT USERS failed", e);
        }
    }

    private static void set(PreparedStatement ps, Object... params) throws SQLException {
        for (int i = 0; i < params.length; i++) ps.setObject(i + 1, params[i]);
    }

    private static Users map(ResultSet rs) throws SQLException {
        Users u = new Users();
        u.setId(rs.getString(COL_ID));                 // ánh xạ về idAuthor qua alias getId/setId
        u.setPassword(rs.getString("Password"));
        u.setFullname(rs.getString("Fullname"));
        java.sql.Date d = rs.getDate("Birthday");
        u.setBirthday(d == null ? null : new java.util.Date(d.getTime()));
        u.setGender((Boolean) rs.getObject("Gender")); // giữ được null
        u.setMobile(rs.getString("Mobile"));
        u.setEmail(rs.getString("Email"));
        u.setRole((Boolean) rs.getObject("Role"));
        return u;
    }
}
