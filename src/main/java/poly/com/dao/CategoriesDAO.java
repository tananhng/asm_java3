package poly.com.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import poly.com.model.Category;
import poly.com.utils.JDBC;

public class CategoriesDAO extends Asm<Category, String> {

    @Override
    public void insert(Category e) {
        final String sql = "INSERT INTO dbo.CATEGORIES (Id, Name) VALUES (?,?)";
        try {
            JDBC.executeUpdate(sql, e.getId(), e.getName());
        } catch (SQLException ex) {
            throw new RuntimeException("Insert CATEGORIES failed", ex);
        }
    }

    @Override
    public void update(Category e) {
        final String sql = "UPDATE dbo.CATEGORIES SET Name=? WHERE Id=?";
        try {
            JDBC.executeUpdate(sql, e.getName(), e.getId());
        } catch (SQLException ex) {
            throw new RuntimeException("Update CATEGORIES failed (Id=" + e.getId() + ")", ex);
        }
    }

    @Override
    public void delete(String id) {
        final String sql = "DELETE FROM dbo.CATEGORIES WHERE Id=?";
        try {
            JDBC.executeUpdate(sql, id);
        } catch (SQLException ex) {
            throw new RuntimeException("Delete CATEGORIES failed (Id=" + id + ")", ex);
        }
    }

    @Override
    public Category selectById(String id) {
        final String sql = "SELECT * FROM dbo.CATEGORIES WHERE Id=?";
        List<Category> list = selectBySql(sql, id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<Category> selectAll() {
        final String sql = "SELECT * FROM dbo.CATEGORIES ORDER BY Name ASC";
        return selectBySql(sql);
    }

    @Override
    public List<Category> selectBySql(String sql, Object... args) {
        List<Category> list = new ArrayList<>();
        try (var rs = JDBC.executeQuery(sql, args)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (Exception ex) {
            throw new RuntimeException("Query CATEGORIES failed", ex);
        }
        return list;
    }

    /** Đếm tất cả category */
    public int countAll() {
        final String sql = "SELECT COUNT(*) FROM dbo.CATEGORIES";
        try (var rs = JDBC.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (Exception ex) {
            throw new RuntimeException("Count CATEGORIES failed", ex);
        }
    }

    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setId(rs.getString("Id"));
        c.setName(rs.getString("Name"));
        return c;
        // Nếu bạn có thêm field khác, map tại đây.
    }
}
