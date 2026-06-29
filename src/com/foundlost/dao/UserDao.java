package com.foundlost.dao;

import com.foundlost.bean.User;
import com.foundlost.util.DBUtil;
import com.foundlost.util.MD5Util;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDao {

    public User login(String username, String password) {
        String sql = "SELECT * FROM user WHERE username=? AND password=? AND status=1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rowToUser(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public User findById(int id) {
        String sql = "SELECT * FROM user WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rowToUser(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean register(User user) {
        String sql = "INSERT INTO user(username,password,real_name,phone,email) VALUES(?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRealName());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getEmail());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean existUsername(String username) {
        String sql = "SELECT COUNT(*) FROM user WHERE username=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateProfile(User user) {
        // If password is provided (non-empty non-null), update it too
        if (user.getPassword() != null && !user.getPassword().trim().isEmpty()) {
            String sql = "UPDATE user SET real_name=?,phone=?,email=?,password=? WHERE id=?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getRealName());
                ps.setString(2, user.getPhone());
                ps.setString(3, user.getEmail());
                ps.setString(4, user.getPassword());
                ps.setInt(5, user.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) { e.printStackTrace(); }
        } else {
            String sql = "UPDATE user SET real_name=?,phone=?,email=? WHERE id=?";
            try (Connection conn = DBUtil.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, user.getRealName());
                ps.setString(2, user.getPhone());
                ps.setString(3, user.getEmail());
                ps.setInt(4, user.getId());
                return ps.executeUpdate() > 0;
            } catch (SQLException e) { e.printStackTrace(); }
        }
        return false;
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM user";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<User> findByPage(int offset, int pageSize) {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM user ORDER BY create_time DESC LIMIT ?,?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rowToUser(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateStatus(int id, int status) {
        String sql = "UPDATE user SET status=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private User rowToUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setPassword(rs.getString("password"));
        u.setRealName(rs.getString("real_name"));
        u.setPhone(rs.getString("phone"));
        u.setEmail(rs.getString("email"));
        u.setAvatar(rs.getString("avatar"));
        u.setRole(rs.getInt("role"));
        u.setStatus(rs.getInt("status"));
        u.setCreateTime(rs.getTimestamp("create_time"));
        return u;
    }
}