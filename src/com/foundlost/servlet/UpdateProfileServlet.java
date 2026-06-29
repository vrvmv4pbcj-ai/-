package com.foundlost.servlet;

import com.foundlost.service.UserService;
import com.foundlost.bean.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class UpdateProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.getWriter().write("{\"code\":1,\"msg\":\"请先登录\"}");
            return;
        }

        String realName = req.getParameter("realName");
        String phone = req.getParameter("phone");
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (realName != null) user.setRealName(realName);
        if (phone != null) user.setPhone(phone);
        if (email != null) user.setEmail(email);
        if (password != null && !password.trim().isEmpty()) {
            user.setPassword(password);
        }

        boolean ok = new UserService().updateProfile(user);
        if (ok) {
            req.getSession().setAttribute("user", user);
            resp.getWriter().write("{\"code\":0,\"msg\":\"修改成功\"}");
        } else {
            resp.getWriter().write("{\"code\":1,\"msg\":\"修改失败\"}");
        }
    }
}