package poly.com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.Date;
import java.util.Locale;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import jakarta.servlet.jsp.jstl.core.Config;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.beanutils.converters.DateConverter;
import org.apache.commons.beanutils.converters.BooleanConverter;

import poly.com.dao.NewsDAO;
import poly.com.dao.UsersDAO;
import poly.com.dao.CategoriesDAO;
import poly.com.dao.NewsletterDAO;

import poly.com.model.Users;
import poly.com.model.news;
import poly.com.model.Newsletter;
import poly.com.model.Category;
import poly.com.utils.Utf8Control;

@WebServlet(
    name = "ServletAdmin",
    urlPatterns = {"/admin", "/admin-categories", "/login", "/logout"}
)
@MultipartConfig
public class ServletAdmin extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";

    private final NewsDAO newsDAO = new NewsDAO();
    private final UsersDAO usersDAO = new UsersDAO();
    private final CategoriesDAO categoriesDAO = new CategoriesDAO();
    private final NewsletterDAO newsletterDAO = new NewsletterDAO();

    static {
        DateConverter dateConverter = new DateConverter(null);
        dateConverter.setPattern("yyyy-MM-dd");
        ConvertUtils.register(dateConverter, Date.class);

        BooleanConverter booleanConverter = new BooleanConverter(null);
        ConvertUtils.register(booleanConverter, Boolean.class);
    }

    /* ========= i18n: set JSTL locale + bundle UTF-8 ========= */
    private void applyI18n(HttpServletRequest req) {
        HttpSession session = req.getSession();
        String qLang = req.getParameter("lang");
        if (qLang != null && !qLang.isBlank()) {
            session.setAttribute("lang", qLang);
        }
        String current = (String) session.getAttribute("lang");
        if (current == null || current.isBlank()) current = "vi";
        Locale locale = Locale.forLanguageTag(current);

        try {
            // basename "messages" vì header.jsp cũng dùng messages.*
            ResourceBundle bundle = ResourceBundle.getBundle("messages", locale, new Utf8Control());
            Config.set(session, Config.FMT_LOCALE, locale);
            Config.set(session, Config.FMT_LOCALIZATION_CONTEXT,
                new jakarta.servlet.jsp.jstl.fmt.LocalizationContext(bundle, locale));
        } catch (MissingResourceException ignore) {
            Config.set(session, Config.FMT_LOCALE, locale);
        }
    }
    /* ========================================================= */

    // ================== GET ==================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        setUTF8(req, resp);
        applyI18n(req);
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
        final boolean isCategoryRoute = uri.contains("/admin-categories");
        final String id = req.getParameter("id");

        try {
            if (isCategoryRoute) {
                // ========== /admin-categories ==========
                if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                String action = param(req, "action", "list");

                switch (action) {
                    case "edit":
                        Category editing = null;
                        if (id != null && !id.isBlank()) {
                            editing = categoriesDAO.selectById(id);
                            if (editing == null) req.setAttribute("message", "Không tìm thấy loại #" + id);
                        }
                        forwardCategoryForm(req, resp, editing);
                        break;

                    case "delete":
                        if (id != null && !id.isBlank()) {
                            try {
                                categoriesDAO.delete(id);
                                req.setAttribute("message", "Đã xoá loại: " + id);
                            } catch (Exception ex) {
                                req.setAttribute("message", "Xoá thất bại: " + ex.getMessage());
                            }
                        }
                        forwardCategoryList(req, resp);
                        break;

                    case "list":
                    default:
                        forwardCategoryList(req, resp);
                        break;
                }
                return;
            }

            // ========== /admin ==========
            String action = param(req, "action", isAdmin ? "dashboard" : "list");

            switch (action) {
                case "dashboard":
                    if (!isAdmin) { resp.sendRedirect(req.getContextPath() + "/admin?action=list"); return; }
                    forwardDashboard(req, resp);
                    break;

                // alias cũ cho Categories
                case "categories":
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    resp.sendRedirect(req.getContextPath() + "/admin-categories?action=list");
                    break;

                // ===== USERS =====
                case "users":
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    forwardUserList(req, resp);
                    break;

                case "users-edit":
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    Users editing = null;
                    if (id != null && !id.isBlank()) {
                        editing = usersDAO.selectById(id);
                        if (editing == null) req.setAttribute("message", "Không tìm thấy người dùng #" + id);
                    }
                    forwardUserForm(req, resp, editing);
                    break;

                case "users-delete":
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    if (id != null && !id.isBlank()) {
                        try {
                            usersDAO.delete(id);
                            req.setAttribute("message", "Đã xoá người dùng: " + id);
                        } catch (Exception ex) {
                            req.setAttribute("message", "Xoá thất bại: " + ex.getMessage());
                        }
                    }
                    forwardUserList(req, resp);
                    break;

                // ===== NEWSLETTERS =====
                case "newsletters":
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    forwardNewsletterList(req, resp);
                    break;

                case "newsletters-edit":
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    String email = req.getParameter("email");
                    if (email != null && !email.isBlank()) {
                        Newsletter n = newsletterDAO.selectById(email);
                        if (n == null) req.setAttribute("message", "Không tìm thấy email: " + email);
                        else req.setAttribute("newsletterEditing", n);
                    }
                    forwardNewsletterForm(req, resp);
                    break;

                case "newsletters-delete":
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    String emailDel = req.getParameter("email");
                    if (emailDel != null && !emailDel.isBlank()) {
                        try {
                            newsletterDAO.delete(emailDel);
                            req.setAttribute("message", "Đã xoá: " + emailDel);
                        } catch (Exception ex) {
                            req.setAttribute("message", "Xoá thất bại: " + ex.getMessage());
                        }
                    }
                    forwardNewsletterList(req, resp);
                    break;

                // ===== NEWS =====
                case "news-edit": // form tạo mới
                    forwardNewsForm(req, resp, null, isAdmin);
                    break;

                case "edit": { // form sửa theo id (tương thích news-list cũ)
                    news n = null;
                    if (id != null && !id.isBlank()) {
                        n = newsDAO.selectById(id);
                        if (n == null) {
                            req.setAttribute("message", "Không tìm thấy bản tin #" + id);
                            forwardNewsList(req, resp, me, isAdmin);
                            return;
                        }
                        if (!isAdmin && !me.getId().equals(n.getIdAuthor())) {
                            req.setAttribute("message", "Bạn không có quyền sửa bản tin này.");
                            forwardNewsList(req, resp, me, isAdmin);
                            return;
                        }
                    }
                    forwardNewsForm(req, resp, n, isAdmin);
                    break;
                }

                case "delete":
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
                    break;

                case "list":
                default:
                    forwardNewsList(req, resp, me, isAdmin);
                    break;
            }

        } catch (Exception ex) {
            req.setAttribute("message", "Lỗi: " + ex.getMessage());
            if (isCategoryRoute) forwardCategoryList(req, resp);
            else forwardNewsList(req, resp, me, isAdmin);
        }
    }

    // ================== POST ==================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUTF8(req, resp);
        applyI18n(req);
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

        // ---- ADMIN cần đăng nhập ----
        Users me = (Users) req.getSession().getAttribute("user");
        if (me == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        addNoCache(resp);

        final boolean isAdmin = Boolean.TRUE.equals(me.getRole());
        final boolean isCategoryRoute = uri.contains("/admin-categories");
        String action = param(req, "action", "");

        try {
            if (isCategoryRoute) {
                if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                switch (action) {
                    case "create": {
                        Category c = new Category();
                        BeanUtils.populate(c, req.getParameterMap());
                        categoriesDAO.insert(c);
                        req.setAttribute("message", "Thêm loại tin thành công!");
                        forwardCategoryList(req, resp);
                        break;
                    }
                    case "update": {
                        Category c = new Category();
                        BeanUtils.populate(c, req.getParameterMap());
                        categoriesDAO.update(c);
                        req.setAttribute("message", "Cập nhật loại tin thành công!");
                        forwardCategoryList(req, resp);
                        break;
                    }
                    default:
                        forwardCategoryList(req, resp);
                        break;
                }
                return;
            }

            // ===== /admin actions =====
            switch (action) {
                // ===== NEWS =====
                case "create": {
                    news n = new news();
                    BeanUtils.populate(n, req.getParameterMap());
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
                    break;
                }
                case "update": {
                    String id = req.getParameter("id");
                    if (id == null || id.isBlank())
                        throw new IllegalArgumentException("Thiếu id");

                    news n = newsDAO.selectById(id);
                    if (n == null) throw new IllegalArgumentException("Không tìm thấy bản tin #" + id);

                    if (!isAdmin && !me.getId().equals(n.getIdAuthor())) {
                        req.setAttribute("message", "Bạn không có quyền cập nhật bản tin này.");
                        forwardNewsList(req, resp, me, isAdmin);
                        return;
                    }

                    BeanUtils.populate(n, req.getParameterMap());
                    if (n.getPostedDate() == null) n.setPostedDate(new Date());
                    if (n.getViewCount() == null)  n.setViewCount(0);
                    n.setHome(req.getParameter("home") != null);
                    if (!isAdmin) n.setIdAuthor(me.getId());

                    String img = handleUpload(req, "image");
                    if (img != null && !img.isBlank()) n.setImage(img);

                    newsDAO.update(n);
                    req.setAttribute("message", "Sửa thành công");
                    forwardNewsList(req, resp, me, isAdmin);
                    break;
                }

                // ===== USERS =====
                case "users-create": {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    Users newUser = new Users();
                    BeanUtils.populate(newUser, req.getParameterMap());
                    newUser.setRole(req.getParameter("role") != null);
                    usersDAO.insert(newUser);
                    req.setAttribute("message", "Thêm người dùng mới thành công!");
                    forwardUserList(req, resp);
                    break;
                }
                case "users-update": {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    Users existingUser = new Users();
                    BeanUtils.populate(existingUser, req.getParameterMap());
                    existingUser.setRole(req.getParameter("role") != null);
                    String password = req.getParameter("password");
                    if (password == null || password.isBlank()) {
                        Users oldUser = usersDAO.selectById(existingUser.getId());
                        if (oldUser != null) existingUser.setPassword(oldUser.getPassword());
                    }
                    usersDAO.update(existingUser);
                    req.setAttribute("message", "Cập nhật người dùng thành công!");
                    forwardUserList(req, resp);
                    break;
                }

                // ===== NEWSLETTERS =====
                case "newsletters-create": {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    String email = req.getParameter("email");
                    boolean enabled = req.getParameter("enabled") != null;
                    Newsletter n = new Newsletter();
                    n.setEmail(email);
                    n.setEnabled(enabled);
                    newsletterDAO.insert(n);
                    req.setAttribute("message", "Thêm email thành công!");
                    forwardNewsletterList(req, resp);
                    break;
                }
                case "newsletters-update": {
                    if (!isAdmin) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
                    String email = req.getParameter("email");
                    boolean enabled = req.getParameter("enabled") != null;
                    Newsletter n = newsletterDAO.selectById(email);
                    if (n == null) throw new IllegalArgumentException("Không tìm thấy: " + email);
                    n.setEnabled(enabled);
                    newsletterDAO.update(n);
                    req.setAttribute("message", "Cập nhật thành công!");
                    forwardNewsletterList(req, resp);
                    break;
                }

                default:
                    forwardNewsList(req, resp, me, isAdmin);
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("message", "Lỗi: " + e.getMessage());
            if (isCategoryRoute) forwardCategoryList(req, resp);
            else forwardNewsList(req, resp, me, isAdmin);
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

    private void forwardCategoryForm(HttpServletRequest req, HttpServletResponse resp, Category editing)
            throws ServletException, IOException {
        attachStats(req);
        if (editing != null) req.setAttribute("categoryEditing", editing);
        req.getRequestDispatcher("/WEB-INF/views/admin/category-form.jsp").forward(req, resp);
    }

    private void forwardUserList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        attachStats(req);
        req.setAttribute("usersList", usersDAO.selectAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/user-list.jsp").forward(req, resp);
    }

    private void forwardUserForm(HttpServletRequest req, HttpServletResponse resp, Users editing)
            throws ServletException, IOException {
        attachStats(req);
        if (editing != null) req.setAttribute("userEditing", editing);
        req.getRequestDispatcher("/WEB-INF/views/admin/user-form.jsp").forward(req, resp);
    }

    private void forwardNewsletterList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        attachStats(req);
        req.setAttribute("subs", newsletterDAO.selectAll());
        req.getRequestDispatcher("/WEB-INF/views/admin/newsletter-list.jsp").forward(req, resp);
    }

    private void forwardNewsletterForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        attachStats(req);
        req.getRequestDispatcher("/WEB-INF/views/admin/newsletter-form.jsp").forward(req, resp);
    }

    private void forwardNewsForm(HttpServletRequest req, HttpServletResponse resp, news editing, boolean isAdmin)
            throws ServletException, IOException {
        attachStats(req);
        req.setAttribute("isAdmin", isAdmin);
        req.setAttribute("categoriesList", categoriesDAO.selectAll());
        req.setAttribute("usersList", usersDAO.selectAll());
        if (editing != null) req.setAttribute("newsEditing", editing);
        req.getRequestDispatcher("/WEB-INF/views/admin/news-form.jsp").forward(req, resp);
    }

    private void forwardNewsList(HttpServletRequest req, HttpServletResponse resp, Users me, boolean isAdmin)
            throws ServletException, IOException {
        attachStats(req);
        req.setAttribute("isAdmin", isAdmin);
        req.setAttribute("categoriesList", categoriesDAO.selectAll());
        if (isAdmin) req.setAttribute("newsList", newsDAO.selectAll());
        else         req.setAttribute("newsList", newsDAO.selectByAuthor(me.getId()));
        req.getRequestDispatcher("/WEB-INF/views/admin/news-list.jsp").forward(req, resp);
    }

    private void attachStats(HttpServletRequest req) {
        long news = newsDAO.countAll();
        long cats = categoriesDAO.countAll();
        long users = usersDAO.countAll();
        long subs = newsletterDAO.countAll();

        req.setAttribute("totalNews",        news);
        req.setAttribute("totalCategories",  cats);
        req.setAttribute("totalUsers",       users);
        req.setAttribute("totalSubscribers", subs);

        // aliases
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

    /** Lưu file upload và trả về đường dẫn tương đối */
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
