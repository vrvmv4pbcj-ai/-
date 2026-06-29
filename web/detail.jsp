<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.foundlost.bean.*,com.foundlost.service.*,java.util.*" %>
<% request.setCharacterEncoding("UTF-8");
    Item item = (Item) request.getAttribute("item");
    if (item == null) { response.sendRedirect("index.jsp"); return; }
    User loginUser = (User) session.getAttribute("user");
    List<Message> messages = new MessageService().findByItemId(item.getId());
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= item.getTitle() %> · 校园失物招领</title>
    <link rel="stylesheet" href="https://cdn.bootcdn.net/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
<nav class="navbar">
    <a href="../index.jsp" class="navbar-brand"><div class="logo-icon">🎓</div>校园失物招领</a>
    <div class="navbar-nav">
        <a href="../index.jsp"><i class="fa-solid fa-house"></i> 首页</a>
        <% if (loginUser != null) { %>
            <a href="../publish.jsp" class="btn-nav"><i class="fa-solid fa-plus"></i> 发布</a>
            <a href="my"><i class="fa-solid fa-list-check"></i> 我的发布</a>
            <a href="../profile.jsp"><i class="fa-solid fa-user-gear"></i> 个人中心</a>
            <span class="user-name"><%= loginUser.getRealName() != null ? loginUser.getRealName() : loginUser.getUsername() %></span>
            <a href="../logout"><i class="fa-solid fa-right-from-bracket"></i> 退出</a>
        <% } else { %>
            <a href="../login.jsp"><i class="fa-solid fa-right-to-bracket"></i> 登录</a>
        <% } %>
    </div>
</nav>

<div class="container" style="padding-top:28px;padding-bottom:40px;">
    <div class="detail-layout">
        <!-- 左侧详情 -->
        <div>
            <div class="card animate-in">
                <div class="detail-header">
                    <h2>
                        <% if (item.getType() == 1) { %>
                            <span class="tag tag-found" style="vertical-align:middle;margin-right:8px;">招领</span>
                        <% } else { %>
                            <span class="tag tag-lost" style="vertical-align:middle;margin-right:8px;">寻物</span>
                        <% } %>
                        <%= item.getTitle() %>
                    </h2>
                    <div class="detail-header-meta">
                        <span><i class="fa-regular fa-user"></i>&nbsp; <%= item.getUserName() != null ? item.getUserName() : "未知" %></span>
                        <span><i class="fa-regular fa-clock"></i>&nbsp; <%= item.getCreateTime() != null ? item.getCreateTime().toString().substring(0, 16) : "" %></span>
                    </div>
                </div>

                <% if (item.getImage() != null && !item.getImage().isEmpty()) { %>
                <div class="detail-img-wrap">
                    <img src="../<%= item.getImage() %>" alt="物品图片">
                </div>
                <% } %>

                <div class="info-grid">
                    <div class="info-cell">
                        <div class="info-cell-label">物品分类</div>
                        <div class="info-cell-value"><%= item.getCategoryName() != null ? item.getCategoryName() : "-" %></div>
                    </div>
                    <div class="info-cell">
                        <div class="info-cell-label">地点</div>
                        <div class="info-cell-value"><%= item.getLocation() != null && !item.getLocation().isEmpty() ? item.getLocation() : "未填写" %></div>
                    </div>
                    <div class="info-cell">
                        <div class="info-cell-label">日期</div>
                        <div class="info-cell-value"><%= item.getItemDate() != null ? item.getItemDate() : "未填写" %></div>
                    </div>
                    <div class="info-cell">
                        <div class="info-cell-label">联系人</div>
                        <div class="info-cell-value"><%= item.getContactName() != null ? item.getContactName() : "-" %></div>
                    </div>
                    <div class="info-cell">
                        <div class="info-cell-label">联系电话</div>
                        <div class="info-cell-value"><%= item.getContactPhone() != null ? item.getContactPhone() : "-" %></div>
                    </div>
                </div>

                <div class="description-box">
                    <strong style="display:block;margin-bottom:6px;"><i class="fa-solid fa-align-left"></i>&nbsp; 详细描述</strong>
                    <p><%= item.getDescription() != null && !item.getDescription().isEmpty() ? item.getDescription() : "暂无详细描述" %></p>
                </div>
            </div>
        </div>

        <!-- 右侧留言 -->
        <div>
            <div class="card animate-in">
                <div class="card-header">
                    <i class="fa-solid fa-comments"></i>&nbsp; 留言板
                    <span style="font-size:13px;font-weight:400;color:var(--text-tertiary);">(<%= messages.size() %> 条)</span>
                </div>
                <div class="msg-list">
                    <% for (Message msg : messages) { %>
                    <div class="msg-item">
                        <div class="msg-avatar"><%= (msg.getFromUserName() != null ? msg.getFromUserName() : "U").charAt(0) %></div>
                        <div class="msg-body">
                            <div>
                                <span class="msg-user"><%= msg.getFromUserName() != null ? msg.getFromUserName() : "用户" + msg.getFromUserId() %></span>
                                <span class="msg-time"><%= msg.getCreateTime() != null ? msg.getCreateTime().toString().substring(0, 16) : "" %></span>
                            </div>
                            <div class="msg-text"><%= msg.getContent() %></div>
                        </div>
                    </div>
                    <% } %>
                    <% if (messages.isEmpty()) { %>
                    <div class="empty-state" style="padding:32px 0;">
                        <i class="fa-regular fa-comment-dots"></i>
                        <p>暂无留言</p>
                    </div>
                    <% } %>
                </div>
                <% if (loginUser != null && loginUser.getId() != item.getUserId()) { %>
                <div class="msg-form">
                    <textarea id="msgContent" placeholder="给发布者留言…" rows="2"></textarea>
                    <button class="btn btn-primary" onclick="sendMsg()"><i class="fa-solid fa-paper-plane"></i>&nbsp; 发送</button>
                </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script>
function sendMsg(){
    var c=document.getElementById("msgContent").value.trim();
    if(!c){alert("请输入留言内容");return;}
    var d=new URLSearchParams();
    d.append("itemId","<%= item.getId() %>");
    d.append("toUserId","<%= item.getUserId() %>");
    d.append("content",c);
    fetch("../message",{method:"POST",body:d})
    .then(function(r){return r.json()})
    .then(function(data){alert(data.msg);if(data.code===0)location.reload();});
}
</script>
</body>
</html>