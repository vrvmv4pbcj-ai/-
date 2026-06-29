-- ============================================
-- 校园失物招领系统 数据库初始化脚本
-- ============================================

CREATE DATABASE IF NOT EXISTS foundlost DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE foundlost;

-- 1. 用户表
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user` (
  `id`          INT AUTO_INCREMENT PRIMARY KEY,
  `username`    VARCHAR(32)  NOT NULL UNIQUE COMMENT '用户名',
  `password`    VARCHAR(64)  NOT NULL COMMENT '密码(MD5加密)',
  `real_name`   VARCHAR(16)  DEFAULT '' COMMENT '真实姓名',
  `phone`       VARCHAR(16)  DEFAULT '' COMMENT '手机号',
  `email`       VARCHAR(64)  DEFAULT '' COMMENT '邮箱',
  `avatar`      VARCHAR(128) DEFAULT '' COMMENT '头像路径',
  `role`        TINYINT      DEFAULT 0 COMMENT '0普通用户 1管理员',
  `status`      TINYINT      DEFAULT 1 COMMENT '1正常 0禁用',
  `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. 物品分类表
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category` (
  `id`          INT AUTO_INCREMENT PRIMARY KEY,
  `name`        VARCHAR(32) NOT NULL COMMENT '分类名称',
  `sort_order`  INT         DEFAULT 0 COMMENT '排序',
  `status`      TINYINT     DEFAULT 1 COMMENT '1启用 0禁用',
  `create_time` DATETIME    DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. 物品信息表（招领/寻物）
DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `id`            INT AUTO_INCREMENT PRIMARY KEY,
  `title`         VARCHAR(128) NOT NULL COMMENT '标题',
  `type`          TINYINT      NOT NULL COMMENT '0寻物 1招领',
  `category_id`   INT          NOT NULL COMMENT '分类ID',
  `description`   TEXT         COMMENT '详细描述',
  `image`         VARCHAR(256) DEFAULT '' COMMENT '图片路径',
  `location`      VARCHAR(64)  DEFAULT '' COMMENT '地点',
  `item_date`     DATE         COMMENT '物品日期',
  `contact_name`  VARCHAR(16)  DEFAULT '' COMMENT '联系人',
  `contact_phone` VARCHAR(16)  DEFAULT '' COMMENT '联系电话',
  `user_id`       INT          NOT NULL COMMENT '发布者ID',
  `status`        TINYINT      DEFAULT 1 COMMENT '0待审核 1已发布 2已下架 3已找到/已归还',
  `is_deleted`    TINYINT      DEFAULT 0 COMMENT '0正常 1软删除',
  `create_time`   DATETIME     DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`category_id`) REFERENCES `category`(`id`),
  FOREIGN KEY (`user_id`)     REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. 留言/私信表
DROP TABLE IF EXISTS `message`;
CREATE TABLE `message` (
  `id`           INT AUTO_INCREMENT PRIMARY KEY,
  `item_id`      INT      NOT NULL COMMENT '物品ID',
  `from_user_id` INT      NOT NULL COMMENT '发送者ID',
  `to_user_id`   INT      NOT NULL COMMENT '接收者ID',
  `content`      TEXT     NOT NULL COMMENT '内容',
  `is_read`      TINYINT  DEFAULT 0 COMMENT '0未读 1已读',
  `create_time`  DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`item_id`)      REFERENCES `item`(`id`),
  FOREIGN KEY (`from_user_id`) REFERENCES `user`(`id`),
  FOREIGN KEY (`to_user_id`)   REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. 系统公告表
DROP TABLE IF EXISTS `notice`;
CREATE TABLE `notice` (
  `id`          INT AUTO_INCREMENT PRIMARY KEY,
  `title`       VARCHAR(128) NOT NULL COMMENT '标题',
  `content`     TEXT         NOT NULL COMMENT '内容',
  `user_id`     INT          NOT NULL COMMENT '发布者(管理员)',
  `status`      TINYINT      DEFAULT 1 COMMENT '1显示 0隐藏',
  `create_time` DATETIME     DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 默认数据
INSERT INTO `user` (`username`,`password`,`real_name`,`role`) VALUES
('admin', MD5('admin123'), '系统管理员', 1),
('test',  MD5('test123'),  '测试用户', 0);

INSERT INTO `category` (`name`,`sort_order`) VALUES
('校园卡/证件',1), ('电子产品',2), ('书籍文具',3),
('衣物饰品',4), ('钥匙',5), ('其他',6);

INSERT INTO `item` (`title`,`type`,`category_id`,`description`,`location`,`item_date`,`contact_name`,`contact_phone`,`user_id`,`status`) VALUES
('捡到一张校园卡', 1, 1, '在图书馆二楼捡到一张校园卡，卡号后四位1234', '图书馆', CURDATE(), '张三', '13800001111', 1, 1),
('寻蓝色书包', 0, 3, '蓝色双肩包，里面有三本教材和一个笔袋', '教学楼A201', CURDATE(), '李四', '13800002222', 2, 1);

INSERT INTO `notice` (`title`,`content`,`user_id`) VALUES
('系统上线通知', '校园失物招领系统正式上线！欢迎同学们使用。', 1);
