package com.foundlost.servlet;

import com.foundlost.bean.Message;
import com.foundlost.bean.User;
import com.foundlost.service.MessageService;
import com.foundlost.service.ItemService;
import com.foundlost.bean.Item;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/message")
public class MessageServlet extends HttpServlet {
    private MessageService msgService = new MessageService();

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        User user = (User) req.getSession().getAttribute("user");
        int itemId = Integer.parseInt(req.getParameter("itemId"));
        int toUserId = Integer.parseInt(req.getParameter("toUserId"));
        String content = req.getParameter("content");

        if (content == null || content.trim().isEmpty()) {
            resp.getWriter().write("{\"code\":1,\"msg\":\"内容不能为空\"}");
            return;
        }

        Message msg = new Message();
        msg.setItemId(itemId);
        msg.setFromUserId(user.getId());
        msg.setToUserId(toUserId);
        msg.setContent(content);

        if (msgService.send(msg)) {
            resp.getWriter().write("{\"code\":0,\"msg\":\"发送成功\"}");
        } else {
            resp.getWriter().write("{\"code\":1,\"msg\":\"发送失败\"}");
        }
    }
}
