package poly.com.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.LinkedList;
import java.util.List;
import java.util.regex.Pattern;

import poly.com.dao.NewsDAO;
import poly.com.model.news;

@WebServlet(name = "ServletUsers", urlPatterns = {"/users"})
public class ServletUsers extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String VIEW_HOME       = "/WEB-INF/views/public/home.jsp";
    private static final String VIEW_CATEGORY   = "/WEB-INF/views/public/category-list.jsp";
    private static final String VIEW_DETAIL     = "/WEB-INF/views/public/news-detail.jsp";
    private static final String VIEW_NEWSLETTER = "/WEB-INF/views/public/newsletter.jsp";

    private final NewsDAO newsDAO = new NewsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUTF8(req, resp);

        String view = param(req, "view", "list"); // list | detail | category | newsletter
        switch (view) {
            case "detail"     -> showDetail(req, resp);
            case "category"   -> showCategory(req, resp);
            case "newsletter" -> showNewsletter(req, resp);
            default           -> showList(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUTF8(req, resp);
        String view = req.getParameter("view");
        if ("newsletter".equals(view)) {
            handleNewsletterSubmit(req, resp);
        } else {
            doGet(req, resp);
        }
    }

    // ========= Views =========

    /** Trang chủ: dùng đúng danh sách Trang nhất (Home=1) */
    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("homeLatest", newsDAO.selectHomeLatest(6));
            req.setAttribute("homeMost",   newsDAO.selectHomeMostViewed(6));

            // Nếu muốn thêm danh sách tổng quát (không lọc Home)
            req.setAttribute("latestAll", newsDAO.latest(10));
            req.setAttribute("mostAll",   newsDAO.mostViewed(10));
        } catch (Exception e) {
            req.setAttribute("homeLatest", List.of());
            req.setAttribute("homeMost",   List.of());
            req.setAttribute("latestAll",  List.of());
            req.setAttribute("mostAll",    List.of());
            req.setAttribute("message", "Không tải được dữ liệu: " + e.getMessage());
        }

        // “Đã xem gần đây”
        HttpSession session = req.getSession(false);
        if (session != null) {
            @SuppressWarnings("unchecked")
            LinkedList<news> recent = (LinkedList<news>) session.getAttribute("recent");
            req.setAttribute("recent", recent);
        }
        req.getRequestDispatcher(VIEW_HOME).forward(req, resp);
    }

    private void showCategory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String cat = param(req, "cat", "");
        try {
            List<news> list = (cat.isBlank()) ? newsDAO.selectAll() : newsDAO.selectByCategory(cat);
            req.setAttribute("category", cat);
            req.setAttribute("list", list);

            // Sidebar: vẫn ưu tiên block Trang nhất
            req.setAttribute("homeMost",   newsDAO.selectHomeMostViewed(5));
            req.setAttribute("homeLatest", newsDAO.selectHomeLatest(5));
        } catch (Exception e) {
            req.setAttribute("category", cat);
            req.setAttribute("list", List.of());
            req.setAttribute("homeMost",   List.of());
            req.setAttribute("homeLatest", List.of());
            req.setAttribute("message", "Không tải được dữ liệu: " + e.getMessage());
        }
        req.getRequestDispatcher(VIEW_CATEGORY).forward(req, resp);
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        final String id = param(req, "id", "");
        if (id.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/users?view=list");
            return;
        }

        news n = newsDAO.selectById(id);
        if (n == null) {
            resp.sendRedirect(req.getContextPath() + "/users?view=list");
            return;
        }

        try {
            newsDAO.increaseView(id);
            n.setViewCount((n.getViewCount() == null ? 0 : n.getViewCount()) + 1);
        } catch (Exception ignore) {}

        // recent in session (max 5)
        HttpSession session = req.getSession();
        @SuppressWarnings("unchecked")
        LinkedList<news> recent = (LinkedList<news>) session.getAttribute("recent");
        if (recent == null) recent = new LinkedList<>();
        recent.removeIf(x -> java.util.Objects.equals(x.getId(), n.getId()));
        recent.addFirst(n);
        while (recent.size() > 5) recent.removeLast();
        session.setAttribute("recent", recent);

        // Sidebar “Trang nhất”
        try {
            req.setAttribute("homeMost",   newsDAO.selectHomeMostViewed(5));
            req.setAttribute("homeLatest", newsDAO.selectHomeLatest(5));
        } catch (Exception e) {
            req.setAttribute("homeMost",   List.of());
            req.setAttribute("homeLatest", List.of());
        }

        req.setAttribute("news", n);
        req.getRequestDispatcher(VIEW_DETAIL).forward(req, resp);
    }

    private void showNewsletter(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher(VIEW_NEWSLETTER).forward(req, resp);
    }

    // ========= Handlers =========

    @SuppressWarnings("unchecked")
    private void handleNewsletterSubmit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String email = req.getParameter("email");
        if (isValidEmail(email)) {
            HttpSession s = req.getSession();
            List<String> subs = (List<String>) s.getAttribute("subs");
            if (subs == null) {
                subs = new java.util.ArrayList<>();
                s.setAttribute("subs", subs);
            }
            if (subs.contains(email)) {
                req.setAttribute("message", "Email này đã đăng ký trước đó: " + email);
            } else {
                subs.add(email);
                req.setAttribute("message", "Đăng ký thành công: " + email);
            }
        } else {
            req.setAttribute("message", "Vui lòng nhập email hợp lệ.");
        }
        showNewsletter(req, resp);
    }

    // ========= Helpers =========

    private static void setUTF8(HttpServletRequest req, HttpServletResponse resp) {
        try { req.setCharacterEncoding("UTF-8"); } catch (Exception ignore) {}
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");
    }

    private static boolean isValidEmail(String email) {
        if (email == null) return false;
        String e = email.trim();
        if (e.isEmpty()) return false;
        return Pattern.compile("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$").matcher(e).matches();
    }

    private static String param(HttpServletRequest req, String name, String def) {
        String v = req.getParameter(name);
        return (v == null || v.isBlank()) ? def : v.trim();
    }
}
