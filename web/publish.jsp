<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.*,com.foundlost.service.*,java.util.*" %>
<% request.setCharacterEncoding("UTF-8");
    User loginUser = (User) session.getAttribute("user");
    if (loginUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Category> catList = new CategoryService().findAll();
    String preType = request.getParameter("type");
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>发布信息 · 校园失物招领</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
<nav class="navbar">
    <a href="index.jsp" class="navbar-brand"><div class="logo-icon">🎓</div>校园失物招领</a>
    <div class="navbar-nav">
        <a href="index.jsp"><i class="fa-solid fa-house"></i> 首页</a>
        <a href="publish.jsp" class="btn-nav active"><i class="fa-solid fa-plus"></i> 发布信息</a>
        <a href="item/my"><i class="fa-solid fa-list-check"></i> 我的发布</a>
        <a href="profile.jsp"><i class="fa-solid fa-user-gear"></i> 个人中心</a>
        <span class="user-name"><%= loginUser.getRealName() != null && !loginUser.getRealName().isEmpty() ? loginUser.getRealName() : loginUser.getUsername() %></span>
        <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> 退出</a>
    </div>
</nav>

<div class="container" style="max-width:760px;padding-top:32px;padding-bottom:48px;">
    <div class="card animate-in">
        <div class="card-header">
            <i class="fa-solid fa-pen-to-square"></i>&nbsp; 发布失物招领信息
        </div>
        <form action="item/" method="post" enctype="multipart/form-data" id="publishForm">
            <div class="form-row">
                <div class="form-group">
                    <label><i class="fa-solid fa-tag"></i>&nbsp; 信息类型 *</label>
                    <select name="type" required>
                        <option value="">请选择类型</option>
                        <option value="1" <%= "1".equals(preType) ? "selected" : "" %>>招领 — 我捡到了东西</option>
                        <option value="0" <%= "0".equals(preType) ? "selected" : "" %>>寻物 — 我丢了东西</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-folder"></i>&nbsp; 物品分类 *</label>
                    <select name="categoryId" required>
                        <option value="">请选择分类</option>
                        <% for (Category c : catList) { %>
                            <option value="<%= c.getId() %>"><%= c.getName() %></option>
                        <% } %>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-heading"></i>&nbsp; 标题 *</label>
                <input type="text" name="title" required placeholder="例如：黑色钱包，内有身份证和银行卡">
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-align-left"></i>&nbsp; 详细描述</label>
                <textarea name="description" rows="4" placeholder="描述物品特征、颜色、品牌、拾到/丢失的具体情况…"></textarea>
            </div>
            <div class="form-group">
                <label><i class="fa-solid fa-camera"></i>&nbsp; 物品图片</label>
                <div class="upload-zone" id="uploadZone">
                    <input type="file" name="image" accept="image/*" id="imageInput">
                    <i class="fa-solid fa-cloud-arrow-up"></i>
                    <div class="upload-text" id="uploadText">点击上传物品照片</div>
                    <div class="upload-hint">支持 JPG / PNG / GIF，最大 5MB</div>
                </div>
                <div class="image-preview" id="imagePreview">
                    <img id="previewImg" src="" alt="预览">
                    <button type="button" class="preview-remove" id="previewRemove" title="移除图片">
                        <i class="fa-solid fa-xmark"></i>
                    </button>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label><i class="fa-solid fa-location-dot"></i>&nbsp; 地点</label>
                    <input type="text" name="location" placeholder="如：图书馆二楼自习室">
                </div>
                <div class="form-group">
                    <label><i class="fa-regular fa-calendar"></i>&nbsp; 日期</label>
                    <input type="date" name="itemDate">
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label><i class="fa-solid fa-id-card"></i>&nbsp; 联系人</label>
                    <input type="text" name="contactName" value="<%= loginUser.getRealName() != null ? loginUser.getRealName() : "" %>">
                </div>
                <div class="form-group">
                    <label><i class="fa-solid fa-phone"></i>&nbsp; 联系电话</label>
                    <input type="text" name="contactPhone" value="<%= loginUser.getPhone() != null ? loginUser.getPhone() : "" %>">
                </div>
            </div>
            <button type="submit" class="btn btn-primary btn-lg" style="width:100%;margin-top:4px;">
                <i class="fa-solid fa-paper-plane"></i>&nbsp; 立即发布
            </button>
        </form>
    </div>
</div>

<script>
var imageInput=document.getElementById("imageInput");
var imagePreview=document.getElementById("imagePreview");
var previewImg=document.getElementById("previewImg");
var uploadText=document.getElementById("uploadText");
imageInput.addEventListener("change",function(){
    var f=this.files[0];
    if(f){
        if(f.size>5242880){alert("图片不超过5MB");this.value="";return;}
        var r=new FileReader();
        r.onload=function(e){previewImg.src=e.target.result;imagePreview.classList.add("show");uploadText.textContent=f.name;};
        r.readAsDataURL(f);
    }
});
document.getElementById("previewRemove").addEventListener("click",function(){
    imageInput.value="";imagePreview.classList.remove("show");previewImg.src="";uploadText.textContent="点击上传物品照片";
});
document.getElementById("publishForm").addEventListener("submit",function(e){
    e.preventDefault();
    fetch("item/",{method:"POST",body:new FormData(this)})
    .then(function(r){return r.json().catch(function(){return{code:1,msg:"提交失败"};})})
    .then(function(d){alert(d.msg);if(d.code===0)location.href="item/my";});
});
</script>
</body>
</html>