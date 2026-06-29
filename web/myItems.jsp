<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.*,com.foundlost.service.*,com.foundlost.util.*,java.util.*" %>
<% request.setCharacterEncoding("UTF-8");
    User loginUser = (User) session.getAttribute("user");
    if (loginUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Item> items = (List<Item>) request.getAttribute("items");
    PageBean<Item> pb = (PageBean<Item>) request.getAttribute("pageBean");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>我的发布 · 校园失物招领</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<nav class="navbar">
    <a href="index.jsp" class="navbar-brand"><div class="logo-icon">🎓</div>校园失物招领</a>
    <div class="navbar-nav">
        <a href="index.jsp"><i class="fa-solid fa-house"></i> 首页</a>
        <a href="publish.jsp" class="btn-nav"><i class="fa-solid fa-plus"></i> 发布信息</a>
        <a href="item/my" class="active"><i class="fa-solid fa-list-check"></i> 我的发布</a>
        <a href="profile.jsp"><i class="fa-solid fa-user-gear"></i> 个人中心</a>
        <span class="user-name"><%= loginUser.getRealName() != null ? loginUser.getRealName() : loginUser.getUsername() %></span>
        <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> 退出</a>
    </div>
</nav>

<div class="container" style="padding-top:32px;padding-bottom:40px;">
    <div class="card-header" style="margin-bottom:18px;font-size:18px;">
        <i class="fa-solid fa-list-check" style="color:var(--primary);"></i>&nbsp; 我的发布
    </div>

    <div class="item-grid">
        <% if (items != null) for (Item it : items) { %>
        <div class="item-card animate-in">
            <div class="item-card-img">
                <% if (it.getImage() != null && !it.getImage().isEmpty()) { %>
                    <img src="<%= it.getImage() %>" alt="<%= it.getTitle() %>" loading="lazy">
                <% } else { %>
                    <span class="img-placeholder"><i class="fa-solid fa-image"></i></span>
                <% } %>
            </div>
            <div class="item-card-body">
                <div>
                    <h3><%= it.getTitle() %></h3>
                    <div class="item-tags">
                        <% if (it.getType() == 1) { %>
                            <span class="tag tag-found"><i class="fa-solid fa-hand-holding-heart"></i> 招领</span>
                        <% } else { %>
                            <span class="tag tag-lost"><i class="fa-solid fa-magnifying-glass"></i> 寻物</span>
                        <% } %>
                        <% if (it.getCategoryName() != null) { %>
                            <span class="tag tag-cat"><%= it.getCategoryName() %></span>
                        <% } %>
                    </div>
                    <div class="item-meta">
                        <span><i class="fa-solid fa-location-dot"></i>&nbsp; <%= it.getLocation() != null && !it.getLocation().isEmpty() ? it.getLocation() : "未填写" %></span>
                        <span><i class="fa-regular fa-clock"></i>&nbsp; <%= it.getCreateTime() != null ? it.getCreateTime().toString().substring(0, 16) : "" %></span>
                    </div>
                </div>
                <div class="item-card-footer">
                    <a href="item/detail?id=<%= it.getId() %>" class="btn btn-primary btn-sm">
                        查看详情&nbsp; <i class="fa-solid fa-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <% if (items == null || items.isEmpty()) { %>
    <div class="empty-state animate-in">
        <i class="fa-solid fa-inbox"></i>
        <p>还没有发布过任何信息</p>
        <a href="publish.jsp" class="btn btn-primary btn-lg" style="margin-top:18px;">
            <i class="fa-solid fa-plus"></i>&nbsp; 立即发布
        </a>
    </div>
    <% } %>

    <% if (pb != null && pb.getTotalPage() > 1) { %>
    <div class="pagination">
        <% for (int i = 1; i <= pb.getTotalPage(); i++) { %>
            <% if (i == pb.getPageNum()) { %><span class="current"><%= i %></span>
            <% } else { %><a href="?page=<%= i %>"><%= i %></a><% } %>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>