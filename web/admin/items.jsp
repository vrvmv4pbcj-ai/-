<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.*,com.foundlost.util.*,java.util.*" %>
<% request.setCharacterEncoding("UTF-8");
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || adminUser.getRole() != 1) { response.sendRedirect("../login.jsp"); return; }
    PageBean<Item> pageBean = (PageBean<Item>) request.getAttribute("pageBean");
    List<Item> items = pageBean != null ? pageBean.getList() : new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8"><title>信息审核 · 后台</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<nav class="navbar">
    <a href="../index.jsp" class="navbar-brand"><div class="logo-icon">🎓</div>校园失物招领</a>
    <div class="navbar-nav">
        <a href="../index.jsp"><i class="fa-solid fa-house"></i> 前台</a>
        <span class="user-name"><%= adminUser.getRealName() != null ? adminUser.getRealName() : adminUser.getUsername() %></span>
        <a href="../logout"><i class="fa-solid fa-right-from-bracket"></i> 退出</a>
    </div>
</nav>
<div class="admin-wrapper">
    <div class="admin-sidebar">
        <a href="index.jsp"><i class="fa-solid fa-gauge-high"></i> 控制台</a>
        <a href="users.jsp"><i class="fa-solid fa-users"></i> 用户管理</a>
        <a href="items.jsp" class="active"><i class="fa-solid fa-clipboard-check"></i> 信息审核</a>
        <a href="categories.jsp"><i class="fa-solid fa-folder-tree"></i> 分类管理</a>
        <a href="notices.jsp"><i class="fa-solid fa-bullhorn"></i> 公告管理</a>
    </div>
    <div class="admin-main">
        <h2 style="font-size:20px;font-weight:800;margin-bottom:18px;letter-spacing:-0.02em;">
            <i class="fa-solid fa-clipboard-check" style="color:var(--primary);"></i>&nbsp; 信息审核
        </h2>
        <div class="table-wrap">
            <table>
                <thead><tr><th>ID</th><th>标题</th><th>类型</th><th>发布者</th><th>状态</th><th>时间</th><th>操作</th></tr></thead>
                <tbody>
                    <% for (Item it : items) { %>
                    <tr>
                        <td><%= it.getId() %></td><td><strong><%= it.getTitle() %></strong></td>
                        <td><%= it.getType() == 1 ? "招领" : "寻物" %></td>
                        <td><%= it.getUserName() != null ? it.getUserName() : "-" %></td>
                        <td>
                            <% if (it.getStatus() == 0) { %><span class="status-badge status-pending">待审核</span>
                            <% } else if (it.getStatus() == 1) { %><span class="status-badge status-approved">已通过</span>
                            <% } else { %><span class="status-badge status-rejected">已拒绝</span><% } %>
                        </td>
                        <td><%= it.getCreateTime() != null ? it.getCreateTime().toString().substring(0,16) : "" %></td>
                        <td>
                            <% if (it.getStatus() == 0) { %>
                            <a href="items?action=pass&id=<%= it.getId() %>" class="btn btn-success btn-sm"><i class="fa-solid fa-check"></i></a>
                            <a href="items?action=reject&id=<%= it.getId() %>" class="btn btn-warning btn-sm"><i class="fa-solid fa-xmark"></i></a>
                            <% } %>
                            <a href="items?action=delete&id=<%= it.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('确定删除?')"><i class="fa-solid fa-trash"></i></a>
                        </td>
                    </tr><% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>