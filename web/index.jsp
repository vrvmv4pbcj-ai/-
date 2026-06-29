<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.*,com.foundlost.service.*,com.foundlost.util.*,java.util.*" %>
<% request.setCharacterEncoding("UTF-8");
    CategoryService catService = new CategoryService();
    List<Category> catList = catService.findAll();
    ItemService itemService = new ItemService();
    int pageNum = 1;
    try { pageNum = Integer.parseInt(request.getParameter("page")); } catch(Exception ignored){}
    Integer type = null;
    try { type = Integer.parseInt(request.getParameter("type")); } catch(Exception ignored){}
    Integer categoryId = null;
    try { categoryId = Integer.parseInt(request.getParameter("categoryId")); } catch(Exception ignored){}
    String keyword = request.getParameter("keyword");
    PageBean<Item> pageBean = itemService.findByPage(pageNum, 8, type, categoryId, keyword);
    List<Item> items = pageBean.getList();
    User loginUser = (User) session.getAttribute("user");
    int foundCount = itemService.countByType(1);
    int lostCount = itemService.countByType(0);
    int totalCount = foundCount + lostCount;
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>校园失物招领</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="index.jsp" class="navbar-brand">
        <div class="logo-icon">🎓</div>
        校园失物招领
    </a>
    <div class="navbar-nav">
        <a href="index.jsp" class="active"><i class="fa-solid fa-house"></i> 首页</a>
        <% if (loginUser != null) { %>
            <a href="publish.jsp" class="btn-nav"><i class="fa-solid fa-plus"></i> 发布信息</a>
            <a href="item/my"><i class="fa-solid fa-list-check"></i> 我的发布</a>
            <a href="profile.jsp"><i class="fa-solid fa-user-gear"></i> 个人中心</a>
            <% if (loginUser.getRole() == 1) { %>
                <a href="admin"><i class="fa-solid fa-gear"></i> 后台管理</a>
            <% } %>
            <span class="user-name"><%= loginUser.getRealName() != null && !loginUser.getRealName().isEmpty() ? loginUser.getRealName() : loginUser.getUsername() %></span>
            <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> 退出</a>
        <% } else { %>
            <a href="login.jsp"><i class="fa-solid fa-right-to-bracket"></i> 登录</a>
            <a href="register.jsp" class="btn-nav"><i class="fa-solid fa-user-plus"></i> 注册</a>
        <% } %>
    </div>
</nav>

<!-- Hero Banner -->
<section class="hero">
    <div class="hero-inner">
        <div class="hero-text">
            <h1>校园<span>失物招领</span>平台</h1>
            <p>丢了东西？捡到物品？在这里帮助失物找到主人，让善意在校园流动</p>
            <div class="hero-buttons">
                <a href="publish.jsp?type=1" class="btn btn-primary btn-lg">
                    <i class="fa-solid fa-hand-holding-heart"></i>&nbsp; 发布招领
                </a>
                <a href="publish.jsp?type=0" class="btn btn-outline btn-lg">
                    <i class="fa-solid fa-magnifying-glass"></i>&nbsp; 发布寻物
                </a>
            </div>
        </div>
        <div class="hero-visual">
            <div class="hero-illustration">🔍</div>
            <div class="floating-badge tr"><i class="fa-solid fa-check-circle" style="color:#10B981;"></i>&nbsp; 失物招领</div>
            <div class="floating-badge bl"><i class="fa-solid fa-handshake" style="color:#3B82F6;"></i>&nbsp; 互助社区</div>
        </div>
    </div>
</section>

<div class="container">

    <!-- 统计卡片 -->
    <section class="stats-section animate-in">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon blue"><i class="fa-solid fa-box-archive"></i></div>
                <div class="stat-num"><%= totalCount %></div>
                <div class="stat-label">全部信息</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green"><i class="fa-solid fa-hand-holding-heart"></i></div>
                <div class="stat-num"><%= foundCount %></div>
                <div class="stat-label">招领信息</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon orange"><i class="fa-solid fa-magnifying-glass"></i></div>
                <div class="stat-num"><%= lostCount %></div>
                <div class="stat-label">寻物信息</div>
            </div>
            <div class="stat-card">
                <div class="stat-icon purple"><i class="fa-solid fa-handshake"></i></div>
                <div class="stat-num"><%= totalCount %></div>
                <div class="stat-label">帮助次数</div>
            </div>
        </div>
    </section>

    <!-- 搜索 -->
    <section class="search-section animate-in">
        <div class="card">
            <form class="search-box" action="index.jsp" method="get">
                <select name="type">
                    <option value="">全部类型</option>
                    <option value="1" <%= "1".equals(request.getParameter("type")) ? "selected" : "" %>>招领</option>
                    <option value="0" <%= "0".equals(request.getParameter("type")) ? "selected" : "" %>>寻物</option>
                </select>
                <select name="categoryId">
                    <option value="">全部分类</option>
                    <% for (Category c : catList) { %>
                        <option value="<%= c.getId() %>" <%= String.valueOf(c.getId()).equals(request.getParameter("categoryId")) ? "selected" : "" %>><%= c.getName() %></option>
                    <% } %>
                </select>
                <input type="text" name="keyword" placeholder="搜索物品名称、地点…" value="<%= keyword != null ? keyword : "" %>">
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-search"></i>&nbsp; 搜索</button>
                <a href="index.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-rotate-right"></i>&nbsp; 重置</a>
            </form>
        </div>
    </section>

    <!-- 信息列表 -->
    <section class="item-section">
        <div class="item-grid">
            <% for (Item item : items) { %>
            <div class="item-card animate-in">
                <div class="item-card-img">
                    <% if (item.getImage() != null && !item.getImage().isEmpty()) { %>
                        <img src="<%= item.getImage() %>" alt="<%= item.getTitle() %>" loading="lazy">
                    <% } else { %>
                        <span class="img-placeholder"><i class="fa-solid fa-image"></i></span>
                    <% } %>
                </div>
                <div class="item-card-body">
                    <div>
                        <h3><%= item.getTitle() %></h3>
                        <div class="item-tags">
                            <% if (item.getType() == 1) { %>
                                <span class="tag tag-found"><i class="fa-solid fa-hand-holding-heart"></i> 招领</span>
                            <% } else { %>
                                <span class="tag tag-lost"><i class="fa-solid fa-magnifying-glass"></i> 寻物</span>
                            <% } %>
                            <% if (item.getCategoryName() != null) { %>
                                <span class="tag tag-cat"><%= item.getCategoryName() %></span>
                            <% } %>
                        </div>
                        <div class="item-meta">
                            <span><i class="fa-solid fa-location-dot"></i>&nbsp; <%= item.getLocation() != null && !item.getLocation().isEmpty() ? item.getLocation() : "未填写" %></span>
                            <span><i class="fa-regular fa-clock"></i>&nbsp; <%= item.getCreateTime() != null ? item.getCreateTime().toString().substring(0, 16) : "" %></span>
                            <span><i class="fa-regular fa-user"></i>&nbsp; <%= item.getUserName() != null ? item.getUserName() : "匿名" %></span>
                        </div>
                    </div>
                    <div class="item-card-footer">
                        <a href="item/detail?id=<%= item.getId() %>" class="btn btn-primary btn-sm">
                            查看详情&nbsp; <i class="fa-solid fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

        <% if (items.isEmpty()) { %>
        <div class="empty-state animate-in">
            <i class="fa-solid fa-inbox"></i>
            <p>暂无匹配的物品信息</p>
            <p style="font-size:13px;margin-top:4px;">试试调整筛选条件，或发布第一条信息</p>
        </div>
        <% } %>

        <!-- 分页 -->
        <% if (pageBean.getTotalPage() > 1) { %>
        <div class="pagination animate-in">
            <% if (pageNum > 1) { %>
                <a href="?page=<%= pageNum - 1 %><%= type != null ? "&type=" + type : "" %><%= categoryId != null ? "&categoryId=" + categoryId : "" %><%= keyword != null ? "&keyword=" + java.net.URLEncoder.encode(keyword,"UTF-8") : "" %>"><i class="fa-solid fa-chevron-left"></i></a>
            <% } %>
            <% for (int i = 1; i <= pageBean.getTotalPage(); i++) { %>
                <% if (i == pageNum) { %><span class="current"><%= i %></span>
                <% } else { %><a href="?page=<%= i %><%= type != null ? "&type=" + type : "" %><%= categoryId != null ? "&categoryId=" + categoryId : "" %><%= keyword != null ? "&keyword=" + java.net.URLEncoder.encode(keyword,"UTF-8") : "" %>"><%= i %></a><% } %>
            <% } %>
            <% if (pageNum < pageBean.getTotalPage()) { %>
                <a href="?page=<%= pageNum + 1 %><%= type != null ? "&type=" + type : "" %><%= categoryId != null ? "&categoryId=" + categoryId : "" %><%= keyword != null ? "&keyword=" + java.net.URLEncoder.encode(keyword,"UTF-8") : "" %>"><i class="fa-solid fa-chevron-right"></i></a>
            <% } %>
        </div>
        <% } %>
    </section>
</div>

<!-- 页脚 -->
<footer class="footer">
    <div class="footer-inner" style="justify-content:center;">
        <div class="footer-copy">
            &copy;2026 校园失物招领系统
        </div>
    </div>
</footer>

</body>
</html>