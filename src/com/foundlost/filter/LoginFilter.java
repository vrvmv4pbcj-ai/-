package com.foundlost.filter;

import com.foundlost.bean.User;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class LoginFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        String path = request.getRequestURI();

        // 放行静态资源和登录/注册页面
        if (path.contains("/css/") || path.contains("/js/") || path.contains("/images/") ||
            path.endsWith(".png") || path.endsWith(".jpg") || path.endsWith(".ico") ||
            path.contains("/login") || path.contains("/register")) {
            chain.doFilter(req, resp);
            return;
        }

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 管理员后台权限
        if (path.contains("/admin")) {
            User user = (User) session.getAttribute("user");
            if (user.getRole() != 1) {
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                return;
            }
        }

        chain.doFilter(req, resp);
    }
}
