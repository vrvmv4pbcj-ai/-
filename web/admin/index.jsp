<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.*" %>
<% request.setCharacterEncoding("UTF-8");
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || adminUser.getRole() != 1) { response.sendRedirect("../login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理后台 · 校园失物招领</title>
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
        <a href="index.jsp" class="active"><i class="fa-solid fa-gauge-high"></i> 控制台</a>
        <a href="users.jsp"><i class="fa-solid fa-users"></i> 用户管理</a>
        <a href="items.jsp"><i class="fa-solid fa-clipboard-check"></i> 信息审核</a>
        <a href="categories.jsp"><i class="fa-solid fa-folder-tree"></i> 分类管理</a>
        <a href="notices.jsp"><i class="fa-solid fa-bullhorn"></i> 公告管理</a>
    </div>
    <div class="admin-main">
        <h2 style="font-size:22px;font-weight:800;margin-bottom:4px;letter-spacing:-0.02em;">
            <i class="fa-solid fa-gauge-high" style="color:var(--primary);"></i>&nbsp; 管理控制台
        </h2>
        <p style="color:var(--text-tertiary);margin-bottom:24px;">欢迎回来，<%= adminUser.getRealName() != null ? adminUser.getRealName() : adminUser.getUsername() %></p>
        <div class="stats-grid" style="margin-bottom:24px;">
            <div class="stat-card"><div class="stat-icon blue"><i class="fa-solid fa-users"></i></div><div class="stat-num">—</div><div class="stat-label">用户总数</div></div>
            <div class="stat-card"><div class="stat-icon green"><i class="fa-solid fa-clipboard-list"></i></div><div class="stat-num">—</div><div class="stat-label">信息总数</div></div>
            <div class="stat-card"><div class="stat-icon orange"><i class="fa-solid fa-folder-tree"></i></div><div class="stat-num">—</div><div class="stat-label">分类数量</div></div>
            <div class="stat-card"><div class="stat-icon purple"><i class="fa-solid fa-bullhorn"></i></div><div class="stat-num">—</div><div class="stat-label">公告数量</div></div>
        </div>
        <div class="card">
            <div class="card-header"><i class="fa-solid fa-bolt"></i>&nbsp; 快捷操作</div>
            <div style="display:flex;gap:12px;flex-wrap:wrap;">
                <a href="users.jsp" class="btn btn-primary"><i class="fa-solid fa-users"></i>&nbsp; 用户管理</a>
                <a href="items.jsp" class="btn btn-outline"><i class="fa-solid fa-clipboard-check"></i>&nbsp; 审核信息</a>
                <a href="categories.jsp" class="btn btn-outline"><i class="fa-solid fa-folder-plus"></i>&nbsp; 管理分类</a>
                <a href="notices.jsp" class="btn btn-outline"><i class="fa-solid fa-pen-to-square"></i>&nbsp; 发布公告</a>
            </div>
        </div>
    </div>
</div>
</body>
</html>