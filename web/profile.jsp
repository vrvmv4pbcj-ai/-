<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.User" %>
<% request.setCharacterEncoding("UTF-8");
    User loginUser = (User) session.getAttribute("user");
    if (loginUser == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人中心 · 校园失物招领</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<nav class="navbar">
    <a href="index.jsp" class="navbar-brand"><div class="logo-icon">🎓</div>校园失物招领</a>
    <div class="navbar-nav">
        <a href="index.jsp"><i class="fa-solid fa-house"></i> 首页</a>
        <a href="publish.jsp" class="btn-nav"><i class="fa-solid fa-plus"></i> 发布</a>
        <a href="item/my"><i class="fa-solid fa-list-check"></i> 我的发布</a>
        <a href="profile.jsp" class="active"><i class="fa-solid fa-user-gear"></i> 个人中心</a>
        <span class="user-name"><%= loginUser.getRealName() != null ? loginUser.getRealName() : loginUser.getUsername() %></span>
        <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> 退出</a>
    </div>
</nav>

<div class="container" style="max-width:760px;padding-top:32px;padding-bottom:40px;">
    <div class="card animate-in">
        <div class="card-header"><i class="fa-solid fa-circle-user"></i>&nbsp; 基本信息</div>
        <div class="info-grid">
            <div class="info-cell">
                <div class="info-cell-label">用户名</div>
                <div class="info-cell-value"><%= loginUser.getUsername() %></div>
            </div>
            <div class="info-cell">
                <div class="info-cell-label">真实姓名</div>
                <div class="info-cell-value"><%= loginUser.getRealName() != null && !loginUser.getRealName().isEmpty() ? loginUser.getRealName() : "未填写" %></div>
            </div>
            <div class="info-cell">
                <div class="info-cell-label">手机号</div>
                <div class="info-cell-value"><%= loginUser.getPhone() != null && !loginUser.getPhone().isEmpty() ? loginUser.getPhone() : "未填写" %></div>
            </div>
            <div class="info-cell">
                <div class="info-cell-label">邮箱</div>
                <div class="info-cell-value"><%= loginUser.getEmail() != null && !loginUser.getEmail().isEmpty() ? loginUser.getEmail() : "未填写" %></div>
            </div>
            <div class="info-cell">
                <div class="info-cell-label">注册时间</div>
                <div class="info-cell-value"><%= loginUser.getCreateTime() != null ? loginUser.getCreateTime().toString().substring(0, 16) : "" %></div>
            </div>
        </div>
    </div>

    <div class="card animate-in">
        <div class="card-header"><i class="fa-solid fa-pen-to-square"></i>&nbsp; 修改信息</div>
        <form id="profileForm">
            <div class="form-row">
                <div class="form-group">
                    <label>真实姓名</label>
                    <input type="text" name="realName" value="<%= loginUser.getRealName() != null ? loginUser.getRealName() : "" %>">
                </div>
                <div class="form-group">
                    <label>手机号</label>
                    <input type="text" name="phone" value="<%= loginUser.getPhone() != null ? loginUser.getPhone() : "" %>">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>邮箱</label>
                    <input type="email" name="email" value="<%= loginUser.getEmail() != null ? loginUser.getEmail() : "" %>">
                </div>
                <div class="form-group">
                    <label>新密码（留空不修改）</label>
                    <input type="password" name="password" placeholder="至少6位">
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">
                <i class="fa-solid fa-floppy-disk"></i>&nbsp; 保存修改
            </button>
        </form>
    </div>
</div>

<script>
document.getElementById("profileForm").addEventListener("submit",function(e){
    e.preventDefault();
    var d=new FormData(this);
    fetch("profile",{method:"POST",body:new URLSearchParams(d)})
    .then(function(r){return r.json()})
    .then(function(data){alert(data.msg);if(data.code===0)location.reload();});
});
</script>
</body>
</html>