<%@ page contentType="text/html;charset=UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>注册 · 校园失物招领</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="auth-page">
    <div class="auth-card animate-in">
        <div class="auth-logo"><div class="logo-circle">🎓</div></div>
        <h2>创建账号</h2>
        <p class="auth-subtitle">加入校园失物招领社区</p>
        <form id="registerForm">
            <div class="form-group">
                <label><i class="fa-solid fa-user"></i>&nbsp; 用户名 *</label>
                <input type="text" name="username" required placeholder="3-20位字母或数字">
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-lock"></i>&nbsp; 密码 *</label>
                <input type="password" name="password" required placeholder="至少6位">
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-id-card"></i>&nbsp; 真实姓名</label>
                <input type="text" name="realName" placeholder="方便他人联系你">
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-phone"></i>&nbsp; 手机号</label>
                <input type="text" name="phone" placeholder="选填">
            </div>
            <button type="submit" class="btn btn-primary btn-lg" style="width:100%;">
                <i class="fa-solid fa-user-plus"></i>&nbsp; 立即注册
            </button>
        </form>
        <p class="auth-footer">
            已有账号？<a href="login.jsp">去登录 <i class="fa-solid fa-arrow-right"></i></a>
        </p>
    </div>
</div>
<script>
document.getElementById("registerForm").addEventListener("submit",function(e){
    e.preventDefault();
    var d=new FormData(this);
    fetch("register",{method:"POST",body:new URLSearchParams(d)})
    .then(function(r){return r.json()})
    .then(function(data){alert(data.msg);if(data.code===0)location.href="login.jsp";});
});
</script>
</body>
</html>