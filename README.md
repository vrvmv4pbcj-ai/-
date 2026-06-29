# 校园失物招领系统

> 湖南工程学院 · Web应用开发综合实验 · JavaWeb JSP/Servlet

## 技术栈

- **语言**: Java 8+
- **框架**: JSP + Servlet (JavaWeb)
- **服务器**: Apache Tomcat 8/9
- **数据库**: MySQL 5.7/8.0
- **前端**: HTML + CSS + JavaScript + Ajax
- **工具**: IntelliJ IDEA

## 项目结构

```
foundlost/
├── src/
│   ├── db.properties                  # 数据库配置
│   └── com/foundlost/
│       ├── bean/                      # 实体类
│       │   ├── User.java
│       │   ├── Category.java
│       │   ├── Item.java
│       │   ├── Message.java
│       │   └── Notice.java
│       ├── dao/                       # 数据访问层
│       │   ├── UserDao.java
│       │   ├── CategoryDao.java
│       │   ├── ItemDao.java
│       │   ├── MessageDao.java
│       │   └── NoticeDao.java
│       ├── service/                   # 业务层
│       │   ├── UserService.java
│       │   ├── CategoryService.java
│       │   ├── ItemService.java
│       │   ├── MessageService.java
│       │   └── NoticeService.java
│       ├── servlet/                   # 控制层
│       │   ├── LoginServlet.java
│       │   ├── RegisterServlet.java
│       │   ├── UpdateProfileServlet.java
│       │   ├── LogoutServlet.java
│       │   ├── ItemServlet.java
│       │   ├── MessageServlet.java
│       │   └── AdminServlet.java
│       ├── filter/                    # 过滤器
│       │   ├── EncodingFilter.java
│       │   └── LoginFilter.java
│       └── util/                      # 工具类
│           ├── DBUtil.java
│           ├── MD5Util.java
│           └── PageBean.java
├── web/
│   ├── WEB-INF/web.xml
│   ├── css/style.css
│   ├── *.jsp                         # 前台页面
│   └── admin/*.jsp                   # 后台页面
└── sql/foundlost.sql                 # 数据库初始化脚本
```

## 快速开始

### 1. 准备环境
- 安装 JDK 8+、Tomcat 8+、MySQL
- 将 `mysql-connector-java-8.x.jar` 放入 `web/WEB-INF/lib/`

### 2. 导入 IDEA
1. 打开 IntelliJ IDEA → File → Open → 选择本项目目录
2. File → Project Structure → Modules → 将 `src` 设为 Sources
3. 配置 Tomcat Server: Run → Edit Configurations → + → Tomcat Server → Local
4. Deployment → + → Artifact → foundlost:war exploded

### 3. 初始化数据库
```sql
-- 执行 sql/foundlost.sql
source sql/foundlost.sql;
```

### 4. 修改配置
编辑 `src/db.properties`，填入你的 MySQL 用户名和密码

### 5. 运行
点击 IDEA 的 Run 按钮启动 Tomcat，浏览器访问 `http://localhost:8080`

### 测试账号
| 用户名 | 密码 | 角色 |
|--------|------|------|
| admin | admin123 | 管理员 |
| test | test123 | 普通用户 |

## 功能模块

| 模块 | 功能 |
|------|------|
| 用户系统 | 注册、登录（MD5加密）、Session校验、个人中心 |
| 信息发布 | 发布招领/寻物、上传图片、选择分类 |
| 信息列表 | 按类型/分类/关键词搜索、分页展示 |
| 详情页 | 物品描述、配图、联系信息、留言私信（Ajax） |
| 个人管理 | 查看/下架/删除自己的发布 |
| 后台管理 | 用户管理、信息审核、分类管理、公告管理 |
| 权限控制 | Filter拦截未登录请求、Session校验管理员权限 |

## 数据库设计（5张表）

- **user** — 用户表（含角色字段区分管理员）
- **category** — 物品分类表
- **item** — 物品信息表（多表联查 user + category）
- **message** — 留言私信表
- **notice** — 系统公告表
