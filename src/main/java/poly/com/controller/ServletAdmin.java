package poly.com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Date;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.beanutils.converters.DateConverter;
import org.apache.commons.beanutils.converters.BooleanConverter; // Bổ sung import

import org.apache.commons.beanutils.BeanUtils;

import poly.com.dao.NewsDAO;
import poly.com.dao.UsersDAO;
import poly.com.dao.CategoriesDAO;
import poly.com.dao.NewsletterDAO;
import poly.com.model.Users;
import poly.com.model.news;

@WebServlet(name = "ServletAdmin", urlPatterns = {"/admin", "/login", "/logout"})
@MultipartConfig
public class ServletAdmin extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";

    private final NewsDAO newsDAO = new NewsDAO();
    private final UsersDAO usersDAO = new UsersDAO();
    private final CategoriesDAO categoriesDAO = new CategoriesDAO();
    private final NewsletterDAO newsletterDAO = new NewsletterDAO();

    // ================== KHỞI TẠO STATIC ==================
    // Đăng ký các bộ chuyển đổi cần thiết cho BeanUtils một lần duy nhất.
    static {
        // 1. Cấu hình cho việc chuyển đổi ngày tháng
        DateConverter dateConverter = new DateConverter(null);
        dateConverter.setPattern("yyyy-MM-dd");
        ConvertUtils.register(dateConverter, Date.class);
        
        // 2. Cấu hình cho việc chuyển đổi giá trị Boolean
        //    (Xử lý các chuỗi như "true", "false", "yes", "no", "on", "off")
        BooleanConverter booleanConverter = new BooleanConverter(null);
        ConvertUtils.register(booleanConverter, Boolean.class);
    }
    // ======================================================

    // ================== GET ==================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        setUTF8(req, resp);

        String uri = req.getRequestURI();

        // ---- LOGOUT ----
        if (uri.endsWith("/logout")) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();

            Cookie c = new Cookie("JSESSIONID", "");
            c.setMaxAge(0);
            c.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
            resp.addCookie(c);

            resp.sendRedirect(req.getContextPath() + "/users?view=list");
            return;
        }

        // ---- LOGIN PAGE (GET) ----
        if (uri.endsWith("/login")) {
            if (req.getSession(false) != null && req.getSession(false).getAttribute("user") != null) {
                resp.sendRedirect(req.getContextPath() + "/admin?action=list");
                return;
            }
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        // ---- ADMIN cần đăng nhập ----
        Users me = (Users) req.getSession().getAttribute("user");
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        addNoCache(resp);

        final boolean isAdmin = Boolean.TRUE.equals(me.getRole());
        final String action = param(req, "action", isAdmin ? "dashboard" : "list");
        final String id = req.getParameter("id");

        try {
            switch (action) {
                // ====== Menu chỉ dành cho Admin ======
                case "dashboard" -> {
                    if (!isAdmin) { resp.sendRedirect(req.getContextPath() + "/admin?action=list"); return; }
                    forwardDashboard(req, resp);
                }
                case "categories" -> {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    forwardCategoryList(req, resp);
                }
                case "users" -> {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    forwardUserList(req, resp);
                }
                case "newsletters" -> {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    forwardNewsletterList(req, resp);
                }

                // ====== NEWS CRUD (GET) ======
                case "edit" -> {
                    if (id != null && !id.isBlank()) {
                        news n = newsDAO.selectById(id);
                        if (n == null) {
                            req.setAttribute("message", "Không tìm thấy bản tin #" + id);
                        } else if (!isAdmin && !me.getId().equals(n.getIdAuthor())) {
                            req.setAttribute("message", "Bạn không có quyền sửa bản tin này.");
                        } else {
                            req.setAttribute("newsEditing", n);
                        }
                    }
                    forwardNewsList(req, resp, me, isAdmin);
                }
                case "delete" -> {
                    if (id != null && !id.isBlank()) {
                        news n = newsDAO.selectById(id);
                        if (n == null) {
                            req.setAttribute("message", "Không tìm thấy bản tin #" + id);
                        } else if (!isAdmin && !me.getId().equals(n.getIdAuthor())) {
                            req.setAttribute("message", "Bạn không có quyền xoá bản tin này.");
                        } else {
                            try {
                                newsDAO.delete(id);
                                req.setAttribute("message", "Xóa thành công");
                            } catch (Exception ex) {
                                req.setAttribute("message", "Xóa thất bại: " + ex.getMessage());
                            }
                        }
                    }
                    forwardNewsList(req, resp, me, isAdmin);
                }
             // ====== USERS CRUD (GET) ======
                case "users-edit" -> {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    if (id != null && !id.isBlank()) {
                        Users userToEdit = usersDAO.selectById(id);
                        if (userToEdit != null) {
                            req.setAttribute("userEditing", userToEdit);
                        } else {
                            req.setAttribute("message", "Không tìm thấy người dùng #" + id);
                        }
                    }
                    forwardUserList(req, resp);
                }
                case "users-delete" -> {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    if (id != null && !id.isBlank()) {
                        try {
                            usersDAO.delete(id);
                            req.setAttribute("message", "Xóa người dùng thành công");
                        } catch (Exception ex) {
                            req.setAttribute("message", "Xóa thất bại: " + ex.getMessage());
                        }
                    }
                    forwardUserList(req, resp);
                }

                // ====== NEWS LIST (default) ======
                default -> forwardNewsList(req, resp, me, isAdmin);
            }
        } catch (Exception ex) {
            req.setAttribute("message", "Lỗi: " + ex.getMessage());
            forwardNewsList(req, resp, me, isAdmin);
        }
    }



    // ================== POST ==================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUTF8(req, resp);

        String uri = req.getRequestURI();

        // ---- LOGIN (POST) ----
        if (uri.endsWith("/login")) {
            String id = req.getParameter("idAuthor");
            String pw = req.getParameter("password");
            try {
                Users u = usersDAO.login(id, pw);
                if (u == null) {
                    req.setAttribute("message", "Sai tài khoản / mật khẩu");
                    req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                    return;
                }
                HttpSession s = req.getSession();
                s.setAttribute("user", u);
                s.setMaxInactiveInterval(60 * 60);
                resp.sendRedirect(req.getContextPath() + "/admin?action=list");
                return;
            } catch (Exception e) {
                req.setAttribute("message", "Đăng nhập lỗi: " + e.getMessage());
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                return;
            }
        }

        // ---- ADMIN CRUD (POST) – cần đăng nhập ----
        Users me = (Users) req.getSession().getAttribute("user");
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        addNoCache(resp);
        final boolean isAdmin = Boolean.TRUE.equals(me.getRole());

        String action = param(req, "action", "");
        try {
            switch (action) {
            case "create" -> {
                news n = new news();
                BeanUtils.populate(n, req.getParameterMap());

                // KHÔNG yêu cầu Id, DB tự tăng
                n.setId(null);

                if (n.getPostedDate() == null) n.setPostedDate(new Date());
                if (n.getViewCount() == null)  n.setViewCount(0);
                n.setHome(req.getParameter("home") != null);

                if (!isAdmin) {
                    n.setIdAuthor(me.getId());
                } else if (n.getIdAuthor() == null || n.getIdAuthor().isBlank()) {
                    n.setIdAuthor(me.getId());
                }

                String img = handleUpload(req, "image");
                if (img != null) n.setImage(img);

                newsDAO.insert(n);
                req.setAttribute("message", "Thêm thành công");
                forwardNewsList(req, resp, me, isAdmin);
            }

                case "update" -> {
                    String id = req.getParameter("id");
                    if (id == null || id.isBlank())
                        throw new IllegalArgumentException("Thiếu id");

                    news n = newsDAO.selectById(id);
                    if (n == null) throw new IllegalArgumentException("Không tìm thấy bản tin #" + id);

                    // PV chỉ được sửa bài của mình
                    if (!isAdmin && !me.getId().equals(n.getIdAuthor())) {
                        req.setAttribute("message", "Bạn không có quyền cập nhật bản tin này.");
                        forwardNewsList(req, resp, me, isAdmin);
                        return;
                    }

                    BeanUtils.populate(n, req.getParameterMap());
                    if (n.getPostedDate() == null) n.setPostedDate(new Date());
                    if (n.getViewCount() == null)  n.setViewCount(0);
                    n.setHome(req.getParameter("home") != null);

                    if (!isAdmin) n.setIdAuthor(me.getId()); // tránh đổi tác giả khi PV

                    String img = handleUpload(req, "image");
                    if (img != null && !img.isBlank()) n.setImage(img);

                    newsDAO.update(n);
                    req.setAttribute("message", "Sửa thành công");
                    forwardNewsList(req, resp, me, isAdmin);
                }
             // ====== USERS CRUD (POST) ======
                case "users-create" -> {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    try {
                        Users newUser = new Users();
                        BeanUtils.populate(newUser, req.getParameterMap());
                        // Ghi đè lại giá trị role để đảm bảo tính đúng đắn từ checkbox
                        newUser.setRole(req.getParameter("role") != null);
                        
                        usersDAO.insert(newUser);
                        req.setAttribute("message", "Thêm người dùng mới thành công!");
                    } catch (Exception e) {
                        req.setAttribute("message", "Thêm thất bại: " + e.getMessage());
                        // In ra lỗi để debug
                        e.printStackTrace();
                    }
                    forwardUserList(req, resp);
                }
                case "users-update" -> {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    try {
                        Users existingUser = new Users();
                        BeanUtils.populate(existingUser, req.getParameterMap());
                        // Ghi đè lại giá trị role
                        existingUser.setRole(req.getParameter("role") != null);
                        
                        String password = req.getParameter("password");
                        if (password == null || password.isBlank()) {
                            Users oldUser = usersDAO.selectById(existingUser.getId());
                            if (oldUser != null) {
                                existingUser.setPassword(oldUser.getPassword());
                            }
                        }

                        usersDAO.update(existingUser);
                        req.setAttribute("message", "Cập nhật người dùng thành công!");
                    } catch (Exception e) {
                        req.setAttribute("message", "Cập nhật thất bại: " + e.getMessage());
                        e.printStackTrace();
                    }
                    forwardUserList(req, resp);
                }
                
                default -> forwardNewsList(req, resp, me, isAdmin);
            }
            
            
        } catch (Exception e) {
            req.setAttribute("message", "Lỗi: " + e.getMessage());
            e.printStackTrace();
            forwardNewsList(req, resp, me, isAdmin);
        }
        
    }
    

    // ================== FORWARD HELPERS ==================
    private void forwardDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        attachStats(req);
        req.setAttribute("latestNews", newsDAO.latest(10));
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    private void forwardCategoryList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        attachStats(req);
        req.setAttribute("categoriesList", categoriesDAO.selectAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/category-list.jsp").forward(req, resp);
    }

    private void forwardUserList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        attachStats(req);
        req.setAttribute("usersList", usersDAO.selectAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(req, resp);
    }

    private void forwardNewsletterList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        attachStats(req);
        // đồng bộ với newsletter-list.jsp (dùng newsletterList)
        req.setAttribute("newsletterList", newsletterDAO.selectAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/newsletter-list.jsp").forward(req, resp);
    }

    // Lọc theo quyền: admin = all; PV = bài của tôi
    private void forwardNewsList(HttpServletRequest req, HttpServletResponse resp, Users me, boolean isAdmin)
            throws ServletException, IOException {
        attachStats(req);
        req.setAttribute("isAdmin", isAdmin);
        // cần cho combobox loại trong form tin tức
        req.setAttribute("categoriesList", categoriesDAO.selectAll());

        if (isAdmin) {
            req.setAttribute("newsList", newsDAO.selectAll());
        } else {
            // Yêu cầu NewsDAO có method: public List<news> selectByAuthor(String authorId)
            req.setAttribute("newsList", newsDAO.selectByAuthor(me.getId()));
        }
        req.getRequestDispatcher("/WEB-INF/views/admin/news-list.jsp").forward(req, resp);
    }

    // Giữ bản cũ cho các chỗ gọi chưa chỉnh
    private void forwardNewsList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Users me = (Users) req.getSession().getAttribute("user");
        boolean isAdmin = me != null && Boolean.TRUE.equals(me.getRole());
        forwardNewsList(req, resp, me, isAdmin);
    }

    /** Gắn các thống kê dùng chung cho mọi trang admin */
    private void attachStats(HttpServletRequest req) {
        long news = newsDAO.countAll();
        long cats = categoriesDAO.countAll();
        long users = usersDAO.countAll();
        long subs = newsletterDAO.countAll();

        // Bộ tên total*
        req.setAttribute("totalNews",        news);
        req.setAttribute("totalCategories",  cats);
        req.setAttribute("totalUsers",       users);
        req.setAttribute("totalSubscribers", subs);

        // Alias cho các JSP đang dùng count*
        req.setAttribute("countNews",        news);
        req.setAttribute("countCategories",  cats);
        req.setAttribute("countUsers",       users);
        req.setAttribute("countSubs",        subs);
    }

    // ================== UTILS ==================
    private static String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v == null || v.isBlank()) ? def : v.trim();
    }

    private static void setUTF8(HttpServletRequest req, HttpServletResponse resp) {
        try { req.setCharacterEncoding("UTF-8"); } catch (Exception ignore) {}
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
    }

    /** Lưu file upload vào /uploads và trả về đường dẫn tương đối (uploads/xxx) */
    private String handleUpload(HttpServletRequest req, String partName)
            throws IOException, ServletException {
        Part p = req.getPart(partName);
        if (p == null) return null;
        String fileName = Paths.get(p.getSubmittedFileName()).getFileName().toString();
        if (fileName == null || fileName.isBlank()) return null;

        String root = getServletContext().getRealPath("");
        File dir = new File(root, UPLOAD_DIR);
        if (!dir.exists()) dir.mkdir();

        File out = new File(dir, fileName);
        p.write(out.getAbsolutePath());

        return UPLOAD_DIR + "/" + fileName;
    }

    private static void addNoCache(HttpServletResponse resp) {
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);
    }
}