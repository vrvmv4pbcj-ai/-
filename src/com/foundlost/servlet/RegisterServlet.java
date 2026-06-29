package com.foundlost.servlet;

import com.foundlost.bean.User;
import com.foundlost.service.UserService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private UserService service = new UserService();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        // 确认密码校验
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        if (password == null || !password.equals(confirmPassword)) {
            resp.getWriter().write("{\"code\":1,\"msg\":\"两次输入的密码不一致\"}");
            return;
        }

        User user = new User();
        user.setUsername(req.getParameter("username"));
        user.setPassword(password);
        user.setRealName(req.getParameter("realName"));
        user.setPhone(req.getParameter("phone"));
        user.setEmail(req.getParameter("email"));

        String result = service.register(user);
        if ("success".equals(result)) {
            resp.getWriter().write("{\"code\":0,\"msg\":\"注册成功\"}");
        } else {
            resp.getWriter().write("{\"code\":1,\"msg\":\"" + result + "\"}");
        }
    }
}

