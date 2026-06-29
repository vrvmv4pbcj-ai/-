<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.*,com.foundlost.util.*,java.util.*" %>
<% request.setCharacterEncoding("UTF-8");
    String ctxPath = request.getContextPath();
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || adminUser.getRole() != 1) { response.sendRedirect("../login.jsp"); return; }
    PageBean<User> pageBean = (PageBean<User>) request.getAttribute("pageBean");
    List<User> users = pageBean != null ? pageBean.getList() : new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8"><title>用户管理 · 后台</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="<%=ctxPath%>/css/style.css">
</head>
<body>
<nav class="navbar">
    <a href="<%=ctxPath%>/index.jsp" class="navbar-brand"><div class="logo-icon">🎓</div>校园失物招领</a>
    <div class="navbar-nav">
        <a href="<%=ctxPath%>/index.jsp"><i class="fa-solid fa-house"></i> 前台</a>
        <span class="user-name"><%= adminUser.getRealName() != null ? adminUser.getRealName() : adminUser.getUsername() %></span>
        <a href="<%=ctxPath%>/logout"><i class="fa-solid fa-right-from-bracket"></i> 退出</a>
    </div>
</nav>
<div class="admin-wrapper">
    <div class="admin-sidebar">
        <a href="<%=ctxPath%>/admin/index"><i class="fa-solid fa-gauge-high"></i> 控制台</a>
        <a href="<%=ctxPath%>/admin/users" class="active"><i class="fa-solid fa-users"></i> 用户管理</a>
        <a href="<%=ctxPath%>/admin/items"><i class="fa-solid fa-clipboard-check"></i> 信息审核</a>
        <a href="<%=ctxPath%>/admin/categories"><i class="fa-solid fa-folder-tree"></i> 分类管理</a>
        <a href="<%=ctxPath%>/admin/notices"><i class="fa-solid fa-bullhorn"></i> 公告管理</a>
    </div>
    <div class="admin-main">
        <h2 style="font-size:20px;font-weight:800;margin-bottom:18px;letter-spacing:-0.02em;">
            <i class="fa-solid fa-users" style="color:var(--primary);"></i>&nbsp; 用户管理
        </h2>
        <div class="table-wrap">
            <table>
                <thead><tr><th>ID</th><th>用户名</th><th>姓名</th><th>手机</th><th>角色</th><th>注册时间</th><th>操作</th></tr></thead>
                <tbody>
                    <% for (User u : users) { %>
                    <tr>
                        <td><%= u.getId() %></td><td><strong><%= u.getUsername() %></strong></td>
                        <td><%= u.getRealName() != null ? u.getRealName() : "-" %></td>
                        <td><%= u.getPhone() != null ? u.getPhone() : "-" %></td>
                        <td><%= u.getRole() == 1 ? "<span class='status-badge status-approved'>管理员</span>" : "<span class='status-badge status-pending'>用户</span>" %></td>
                        <td><%= u.getCreateTime() != null ? u.getCreateTime().toString().substring(0,16) : "" %></td>
                        <td>
                            <% if (u.getRole() != 1) { %>
                            <a href="users?action=delete&id=<%= u.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('确定删除?')"><i class="fa-solid fa-trash"></i></a>
                            <% } else { %><span style="color:var(--text-tertiary);">—</span><% } %>
                        </td>
                    </tr><% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>