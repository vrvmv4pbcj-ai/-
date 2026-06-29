<%@ page contentType="text/html;charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>登录 · 校园失物招领</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-card animate-in">
        <div class="auth-logo"><div class="logo-circle">🎓</div></div>
        <h2>欢迎回来</h2>
        <p class="auth-subtitle">登录校园失物招领平台</p>
        <form id="loginForm">
            <div class="form-group">
                <label><i class="fa-solid fa-user"></i>&nbsp; 用户名</label>
                <input type="text" name="username" required placeholder="请输入用户名" autocomplete="username">
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-lock"></i>&nbsp; 密码</label>
                <input type="password" name="password" required placeholder="请输入密码" autocomplete="current-password">
            </div>
            <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">
                <i class="fa-solid fa-right-to-bracket"></i>&nbsp; 登 录
            </button>
        </form>
        <p class="auth-footer">
            还没有账号？<a href="register.jsp">立即注册 <i class="fa-solid fa-arrow-right"></i></a>
        </p>
        
    </div>
</div>
<script>
document.getElementById("loginForm").addEventListener("submit",function(e){
    e.preventDefault();
    var d=new FormData(this);
    fetch("login",{method:"POST",body:new URLSearchParams(d)})
    .then(function(r){return r.json()})
    .then(function(data){if(data.code===0)location.href="index.jsp";else alert(data.msg);});
});
</script>
</body>
</html>