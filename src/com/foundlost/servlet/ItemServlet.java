package com.foundlost.servlet;

import com.foundlost.bean.Item;
import com.foundlost.bean.User;
import com.foundlost.service.ItemService;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.UUID;

@WebServlet("/item/*")
@MultipartConfig
public class ItemServlet extends HttpServlet {
    private ItemService service = new ItemService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getPathInfo();
        if ("/detail".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            req.setAttribute("item", service.findById(id));
            req.getRequestDispatcher("/detail.jsp").forward(req, resp);
        } else if ("/my".equals(path)) {
            User user = (User) req.getSession().getAttribute("user");
            if (user == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
            int pageNum = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
            req.setAttribute("items", service.findMyItems(user.getId(), pageNum, 10).getList());
            req.setAttribute("pageBean", service.findMyItems(user.getId(), pageNum, 10));
            req.getRequestDispatcher("/myItems.jsp").forward(req, resp);
        } else if ("/offline".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            service.offline(id);
            resp.sendRedirect("my");
        } else if ("/delete".equals(path)) {
            int id = Integer.parseInt(req.getParameter("id"));
            service.softDelete(id);
            resp.sendRedirect("my");
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.getWriter().write("{\"code\":1,\"msg\":\"请先登录\"}");
            return;
        }

        Item item = new Item();
        item.setTitle(req.getParameter("title"));
        item.setType(Integer.parseInt(req.getParameter("type")));
        item.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
        item.setDescription(req.getParameter("description"));
        item.setLocation(req.getParameter("location"));
        try {
            item.setItemDate(new SimpleDateFormat("yyyy-MM-dd").parse(req.getParameter("itemDate")));
        } catch (Exception ignored) {}

        // 图片上传
        Part filePart = req.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String submittedName = filePart.getSubmittedFileName();
            String ext = "";
            if (submittedName != null && submittedName.contains(".")) {
                ext = submittedName.substring(submittedName.lastIndexOf("."));
            }
            String fileName = UUID.randomUUID().toString() + ext;
            String uploadDir = getServletContext().getRealPath("/upload");
            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();
            filePart.write(uploadDir + File.separator + fileName);
            item.setImage("upload/" + fileName);
        }

        item.setContactName(req.getParameter("contactName"));
        item.setContactPhone(req.getParameter("contactPhone"));
        item.setUserId(user.getId());

        if (service.publish(item)) {
            resp.getWriter().write("{\"code\":0,\"msg\":\"发布成功\"}");
        } else {
            resp.getWriter().write("{\"code\":1,\"msg\":\"发布失败\"}");
        }
    }
}