<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.User" %>
<% request.setCharacterEncoding("UTF-8");
    User loginUser = (User) session.getAttribute("user");
    String currentPage = (String) request.getAttribute("currentPage");
    if (currentPage == null) currentPage = "";
%>
<nav class="navbar">
    <a href="index.jsp" class="navbar-brand"><div class="logo-icon">🎓</div>校园失物招领</a>
    <div class="navbar-nav">
        <a href="index.jsp" <%= "home".equals(currentPage) ? "class='active'" : "" %>><i class="fa-solid fa-house"></i> 首页</a>
        <% if (loginUser != null) { %>
            <a href="publish.jsp" class="btn-nav"><i class="fa-solid fa-plus"></i> 发布信息</a>
            <a href="item/my"><i class="fa-solid fa-list-check"></i> 我的发布</a>
            <a href="profile.jsp"><i class="fa-solid fa-user-gear"></i> 个人中心</a>
            <% if (loginUser.getRole() == 1) { %><a href="admin/"><i class="fa-solid fa-gear"></i> 后台管理</a><% } %>
            <span class="user-name"><%= loginUser.getRealName() != null && !loginUser.getRealName().isEmpty() ? loginUser.getRealName() : loginUser.getUsername() %></span>
            <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> 退出</a>
        <% } else { %>
            <a href="login.jsp"><i class="fa-solid fa-right-to-bracket"></i> 登录</a>
            <a href="register.jsp" class="btn-nav"><i class="fa-solid fa-user-plus"></i> 注册</a>
        <% } %>
    </div>
</nav>