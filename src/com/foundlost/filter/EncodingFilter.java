package com.foundlost.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebFilter("/*")
public class EncodingFilter implements Filter {
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");

        // 仅对 JSP 和 Servlet 响应设置 Content-Type，静态资源由容器自己处理
        HttpServletRequest httpReq = (HttpServletRequest) req;
        String uri = httpReq.getRequestURI().toLowerCase();
        if (!uri.matches(".*\\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|map)$")) {
            resp.setContentType("text/html;charset=UTF-8");
        }

        chain.doFilter(req, resp);
    }
}