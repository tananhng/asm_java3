package poly.com.dao;

import poly.com.model.news;
import poly.com.utils.JDBC;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewsDAO extends Asm<news, String> {

    /** SELECT nền có JOIN tên loại để luôn có categoryName */
    private static final String BASE_SELECT = """
        SELECT n.Id, n.Title, n.[Content], n.Image, n.PostedDate,
               n.ViewCount, n.Home, n.Id_Author, n.CategoryId,
               c.Name AS categoryName
        FROM dbo.NEWS n
        LEFT JOIN dbo.CATEGORIES c ON c.Id = n.CategoryId
        """;

    // ================== CRUD ==================
    @Override
    public void insert(news e) {
        // Id là IDENTITY -> KHÔNG chèn cột Id
        final String sql = """
            INSERT INTO dbo.NEWS
              (Title, [Content], Image, PostedDate, ViewCount, Home, Id_Author, CategoryId)
            VALUES (?,?,?,?,?,?,?,?)
            """;
        try {
            JDBC.executeUpdate(sql,
                e.getTitle(),
                e.getContent(),
                e.getImage(),
                e.getPostedDate() == null ? null : new Timestamp(e.getPostedDate().getTime()),
                e.getViewCount() == null ? 0 : e.getViewCount(),
                e.getHome() != null && e.getHome(),
                e.getIdAuthor(),
                e.getCategoryId()
            );
        } catch (SQLException ex) {
            throw new RuntimeException("Insert NEWS failed", ex);
        }
    }

    @Override
    public void update(news e) {
        final String sql = """
            UPDATE dbo.NEWS
               SET Title=?,
                   [Content]=?,
                   Image=?,
                   PostedDate=?,
                   ViewCount=?,
                   Home=?,
                   Id_Author=?,
                   CategoryId=?
             WHERE Id=?
            """;
        try {
            JDBC.executeUpdate(sql,
                e.getTitle(),
                e.getContent(),
                e.getImage(),
                e.getPostedDate() == null ? null : new Timestamp(e.getPostedDate().getTime()),
                e.getViewCount() == null ? 0 : e.getViewCount(),
                e.getHome() != null && e.getHome(),
                e.getIdAuthor(),
                e.getCategoryId(),
                e.getId()
            );
        } catch (SQLException ex) {
            throw new RuntimeException("Update NEWS failed (Id=" + e.getId() + ")", ex);
        }
    }

    @Override
    public void delete(String id) {
        final String sql = "DELETE FROM dbo.NEWS WHERE Id=?";
        try { JDBC.executeUpdate(sql, id); }
        catch (SQLException ex) { throw new RuntimeException("Delete NEWS failed (Id=" + id + ")", ex); }
    }

    // ================== Queries ==================
    @Override
    public List<news> selectAll() {
        final String sql = BASE_SELECT + " ORDER BY n.PostedDate DESC";
        return selectBySql(sql);
    }

    public List<news> selectByAuthor(String idAuthor) {
        final String sql = BASE_SELECT + " WHERE n.Id_Author=? ORDER BY n.PostedDate DESC";
        return selectBySql(sql, idAuthor);
    }

    public List<news> selectTopNewsByView() {
        final String sql = BASE_SELECT + " ORDER BY n.ViewCount DESC, n.PostedDate DESC OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY";
        return selectBySql(sql);
    }

    public List<news> selectTopNewsByDate() {
        final String sql = BASE_SELECT + " ORDER BY n.PostedDate DESC OFFSET 0 ROWS FETCH NEXT 5 ROWS ONLY";
        return selectBySql(sql);
    }

    public List<news> selectByCategory(String categoryId) {
        final String sql = BASE_SELECT + " WHERE n.CategoryId=? ORDER BY n.PostedDate DESC";
        return selectBySql(sql, categoryId);
    }

    /** ======= MỚI: chỉ lấy bài Trang nhất (Home = 1) ======= */
    public List<news> selectHomeLatest(int top) {
        final String sql = BASE_SELECT +
            " WHERE n.Home = 1 ORDER BY n.PostedDate DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        return selectBySql(sql, top);
    }

    public List<news> selectHomeMostViewed(int top) {
        final String sql = BASE_SELECT +
            " WHERE n.Home = 1 ORDER BY n.ViewCount DESC, n.PostedDate DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        return selectBySql(sql, top);
    }
    /** ====================================================== */

    public void increaseView(String id) {
        final String sql = "UPDATE dbo.NEWS SET ViewCount = ISNULL(ViewCount,0) + 1 WHERE Id = ?";
        try { JDBC.executeUpdate(sql, id); }
        catch (SQLException e) { throw new RuntimeException("increaseView failed (Id=" + id + ")", e); }
    }

    public List<news> selectPage(int offset, int limit) {
        final String sql = BASE_SELECT + " ORDER BY n.PostedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        return selectBySql(sql, offset, limit);
    }

    public List<news> latest(int top) {
        final String sql = BASE_SELECT + " ORDER BY n.PostedDate DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        return selectBySql(sql, top);
    }

    public List<news> mostViewed(int top) {
        final String sql = BASE_SELECT + " ORDER BY n.ViewCount DESC, n.PostedDate DESC OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        return selectBySql(sql, top);
    }

    public long countAll() {
        final String sql = "SELECT COUNT(*) FROM dbo.NEWS";
        try (ResultSet rs = JDBC.executeQuery(sql)) { return rs.next() ? rs.getLong(1) : 0L; }
        catch (SQLException e) { throw new RuntimeException("countAll NEWS failed", e); }
    }

    public long countHome() {
        final String sql = "SELECT COUNT(*) FROM dbo.NEWS WHERE Home = 1";
        try (ResultSet rs = JDBC.executeQuery(sql)) { return rs.next() ? rs.getLong(1) : 0L; }
        catch (SQLException e) { throw new RuntimeException("countHome NEWS failed", e); }
    }

    public long countByCategory(String categoryId) {
        final String sql = "SELECT COUNT(*) FROM dbo.NEWS WHERE CategoryId = ?";
        try (ResultSet rs = JDBC.executeQuery(sql, categoryId)) { return rs.next() ? rs.getLong(1) : 0L; }
        catch (SQLException e) { throw new RuntimeException("countByCategory NEWS failed", e); }
    }

    @Override
    public news selectById(String id) {
        final String sql = BASE_SELECT + " WHERE n.Id=?";
        List<news> list = selectBySql(sql, id);
        return list.isEmpty() ? null : list.get(0);
    }

    @Override
    public List<news> selectBySql(String sql, Object... args) {
        List<news> list = new ArrayList<>();
        try (ResultSet rs = JDBC.executeQuery(sql, args)) {
            while (rs.next()) list.add(map(rs));
        } catch (Exception ex) {
            throw new RuntimeException("Query NEWS failed", ex);
        }
        return list;
    }

    // ================== Mapper ==================
    private news map(ResultSet rs) throws SQLException {
        news a = new news();
        a.setId(rs.getString("Id"));
        a.setTitle(rs.getString("Title"));
        a.setContent(rs.getString("Content"));
        a.setImage(rs.getString("Image"));

        Timestamp ts = rs.getTimestamp("PostedDate");
        a.setPostedDate(ts == null ? null : new java.util.Date(ts.getTime()));

        a.setViewCount((Integer) rs.getObject("ViewCount"));
        a.setHome((Boolean) rs.getObject("Home"));
        a.setIdAuthor(rs.getString("Id_Author"));
        a.setCategoryId(rs.getString("CategoryId"));
        a.setCategoryName(rs.getString("categoryName"));
        return a;
    }
}
