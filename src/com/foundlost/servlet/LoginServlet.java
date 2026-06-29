package com.foundlost.servlet;

import com.foundlost.bean.User;
import com.foundlost.service.UserService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private UserService service = new UserService();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = service.login(username, password);
        if (user != null) {
            req.getSession().setAttribute("user", user);
            resp.getWriter().write("{\"code\":0,\"msg\":\"登录成功\"}");
        } else {
            resp.getWriter().write("{\"code\":1,\"msg\":\"用户名或密码错误\"}");
        }
    }
}
