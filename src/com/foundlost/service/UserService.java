package com.foundlost.service;

import com.foundlost.bean.User;
import com.foundlost.dao.UserDao;
import com.foundlost.util.MD5Util;
import com.foundlost.util.PageBean;
import java.util.List;

public class UserService {
    private UserDao dao = new UserDao();

    public User login(String username, String password) {
        return dao.login(username, MD5Util.md5(password));
    }

    public User findById(int id) {
        return dao.findById(id);
    }

    public String register(User user) {
        if (user.getUsername() == null || user.getUsername().trim().isEmpty()) return "用户名不能为空";
        if (user.getPassword() == null || user.getPassword().length() < 6) return "密码不能少于6位";
        if (dao.existUsername(user.getUsername())) return "用户名已存在";
        user.setPassword(MD5Util.md5(user.getPassword()));
        return dao.register(user) ? "success" : "注册失败";
    }

    public boolean updateProfile(User user) {
        // If password provided, MD5 it before saving
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            user.setPassword(MD5Util.md5(user.getPassword()));
        }
        return dao.updateProfile(user);
    }

    public PageBean<User> findByPage(int pageNum, int pageSize) {
        int total = dao.getTotalCount();
        PageBean<User> pb = new PageBean<>(pageNum, pageSize, total);
        int offset = (pageNum - 1) * pageSize;
        pb.setList(dao.findByPage(offset, pageSize));
        return pb;
    }

    public boolean updateStatus(int id, int status) {
        return dao.updateStatus(id, status);
    }
}