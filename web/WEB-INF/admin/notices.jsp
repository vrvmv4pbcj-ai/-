<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.*,java.util.*" %>
<% request.setCharacterEncoding("UTF-8");
    User adminUser = (User) session.getAttribute("user");
    if (adminUser == null || adminUser.getRole() != 1) { response.sendRedirect("../login.jsp"); return; }
    List<Notice> noticeList = (List<Notice>) request.getAttribute("noticeList");
    if (noticeList == null) noticeList = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8"><title>公告管理 · 后台</title>
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
        <a href="index"><i class="fa-solid fa-gauge-high"></i> 控制台</a>
        <a href="users"><i class="fa-solid fa-users"></i> 用户管理</a>
        <a href="items"><i class="fa-solid fa-clipboard-check"></i> 信息审核</a>
        <a href="categories"><i class="fa-solid fa-folder-tree"></i> 分类管理</a>
        <a href="notices" class="active"><i class="fa-solid fa-bullhorn"></i> 公告管理</a>
    </div>
    <div class="admin-main">
        <h2 style="font-size:20px;font-weight:800;margin-bottom:18px;letter-spacing:-0.02em;">
            <i class="fa-solid fa-bullhorn" style="color:var(--primary);"></i>&nbsp; 公告管理
        </h2>
        <div class="card" style="margin-bottom:20px;">
            <div class="card-header"><i class="fa-solid fa-plus"></i>&nbsp; 发布公告</div>
            <form action="notices?action=add" method="post">
                <div class="form-group"><label>标题</label><input type="text" name="title" required placeholder="公告标题"></div>
                <div class="form-group"><label>内容</label><textarea name="content" rows="3" required placeholder="公告内容…"></textarea></div>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-paper-plane"></i>&nbsp; 发布公告</button>
            </form>
        </div>
        <div class="table-wrap">
            <table>
                <thead><tr><th>ID</th><th>标题</th><th>内容</th><th>时间</th><th>操作</th></tr></thead>
                <tbody>
                    <% for (Notice n : noticeList) { %>
                    <tr>
                        <td><%= n.getId() %></td><td><strong><%= n.getTitle() %></strong></td>
                        <td style="max-width:260px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"><%= n.getContent() %></td>
                        <td><%= n.getCreateTime() != null ? n.getCreateTime().toString().substring(0,16) : "" %></td>
                        <td><a href="notices?action=noticeDelete&id=<%= n.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('确定删除?')"><i class="fa-solid fa-trash"></i></a></td>
                    </tr><% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>