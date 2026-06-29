package com.foundlost.servlet;

import com.foundlost.bean.User;
import com.foundlost.service.*;
import com.foundlost.bean.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();
        if (path == null) path = "/";
        // 处理带 action 的 GET 请求（审核、删除等）
        String action = req.getParameter("action");
        if (action != null) {
            handleAction(req, resp, action);
            return;
        }

        switch (path) {
            case "/":
                req.getRequestDispatcher("/WEB-INF/admin/index.jsp").forward(req, resp);
                break;
            case "/users":
                loadUsers(req, resp);
                break;
            case "/items":
                loadItems(req, resp);
                break;
            case "/categories":
                loadCategories(req, resp);
                break;
            case "/notices":
                loadNotices(req, resp);
                break;
            default:
                req.getRequestDispatcher("/WEB-INF/admin/index.jsp").forward(req, resp);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        handleAction(req, resp, action);
    }

    private void loadUsers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
        req.setAttribute("pageBean", new UserService().findByPage(page, 10));
        req.getRequestDispatcher("/WEB-INF/admin/users.jsp").forward(req, resp);
    }

    private void loadItems(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
        req.setAttribute("pageBean", new ItemService().findAuditPage(page, 10));
        req.getRequestDispatcher("/WEB-INF/admin/items.jsp").forward(req, resp);
    }

    private void loadCategories(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("catList", new CategoryService().findByPage(1, 100));
        req.getRequestDispatcher("/WEB-INF/admin/categories.jsp").forward(req, resp);
    }

    private void loadNotices(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("noticeList", new NoticeService().findByPage(1, 50));
        req.getRequestDispatcher("/WEB-INF/admin/notices.jsp").forward(req, resp);
    }

    private void chain(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 放行给默认 Servlet 处理
        getServletContext().getNamedDispatcher("default").forward(req, resp);
    }

    private void handleAction(HttpServletRequest req, HttpServletResponse resp, String action)
            throws IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null || user.getRole() != 1) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        switch (action) {
            case "pass": {
                int id = Integer.parseInt(req.getParameter("id"));
                new ItemService().audit(id, 1);
                resp.sendRedirect("items");
                break;
            }
            case "reject": {
                int id = Integer.parseInt(req.getParameter("id"));
                new ItemService().audit(id, 2);
                resp.sendRedirect("items");
                break;
            }
            case "delete": {
                int id = Integer.parseInt(req.getParameter("id"));
                new ItemService().softDelete(id);
                resp.sendRedirect("items");
                break;
            }
            case "userStatus": {
                int id = Integer.parseInt(req.getParameter("id"));
                int status = Integer.parseInt(req.getParameter("status"));
                new UserService().updateStatus(id, status);
                resp.sendRedirect("users");
                break;
            }
            case "addCategory": {
                Category c = new Category();
                c.setName(req.getParameter("name"));
                new CategoryService().add(c);
                resp.sendRedirect("categories");
                break;
            }
            case "categoryDelete": {
                int id = Integer.parseInt(req.getParameter("id"));
                new CategoryService().delete(id);
                resp.sendRedirect("categories");
                break;
            }
            case "addNotice": {
                Notice n = new Notice();
                n.setTitle(req.getParameter("title"));
                n.setContent(req.getParameter("content"));
                n.setUserId(user.getId());
                new NoticeService().add(n);
                resp.sendRedirect("notices");
                break;
            }
            case "noticeDelete": {
                int id = Integer.parseInt(req.getParameter("id"));
                new NoticeService().delete(id);
                resp.sendRedirect("notices");
                break;
            }
        }
    }
}