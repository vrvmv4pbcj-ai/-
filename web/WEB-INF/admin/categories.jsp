<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.*,java.util.*" %>
<% request.setCharacterEncoding("UTF-8");
    String ctxPath = request.getContextPath();
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || adminUser.getRole() != 1) { response.sendRedirect("../login.jsp"); return; }
    List<Category> catList = (List<Category>) request.getAttribute("catList");
    if (catList == null) catList = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8"><title>分类管理 · 后台</title>
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
        <a href="<%=ctxPath%>/admin/users"><i class="fa-solid fa-users"></i> 用户管理</a>
        <a href="<%=ctxPath%>/admin/items"><i class="fa-solid fa-clipboard-check"></i> 信息审核</a>
        <a href="<%=ctxPath%>/admin/categories" class="active"><i class="fa-solid fa-folder-tree"></i> 分类管理</a>
        <a href="<%=ctxPath%>/admin/notices"><i class="fa-solid fa-bullhorn"></i> 公告管理</a>
    </div>
    <div class="admin-main">
        <h2 style="font-size:20px;font-weight:800;margin-bottom:18px;letter-spacing:-0.02em;">
            <i class="fa-solid fa-folder-tree" style="color:var(--primary);"></i>&nbsp; 分类管理
        </h2>
        <div class="card" style="margin-bottom:20px;">
            <form action="<%=ctxPath%>/admin/categories?action=add" method="post" style="display:flex;gap:12px;">
                <input type="text" name="name" required placeholder="输入新分类名称" style="flex:1;padding:11px 16px;border:1.5px solid var(--border);border-radius:12px;font-family:var(--font);font-size:14px;">
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-plus"></i>&nbsp; 添加</button>
            </form>
        </div>
        <div class="table-wrap">
            <table>
                <thead><tr><th>ID</th><th>名称</th><th>创建时间</th><th>操作</th></tr></thead>
                <tbody>
                    <% for (Category c : catList) { %>
                    <tr>
                        <td><%= c.getId() %></td><td><strong><%= c.getName() %></strong></td>
                        <td><%= c.getCreateTime() != null ? c.getCreateTime().toString().substring(0,16) : "" %></td>
                        <td><a href="<%=ctxPath%>/admin/categories?action=categoryDelete&id=<%= c.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('确定删除?')"><i class="fa-solid fa-trash"></i></a></td>
                    </tr><% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>