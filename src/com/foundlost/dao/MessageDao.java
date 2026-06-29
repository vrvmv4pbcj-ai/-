package com.foundlost.dao;

import com.foundlost.bean.Message;
import com.foundlost.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDao {

    public boolean insert(Message msg) {
        String sql = "INSERT INTO message(item_id,from_user_id,to_user_id,content) VALUES(?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, msg.getItemId());
            ps.setInt(2, msg.getFromUserId());
            ps.setInt(3, msg.getToUserId());
            ps.setString(4, msg.getContent());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Message> findByItemId(int itemId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT m.*, u.real_name AS from_user_name FROM message m " +
            "LEFT JOIN user u ON m.from_user_id=u.id WHERE m.item_id=? ORDER BY m.create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, itemId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rowToMsg(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    // 我收到的留言
    public List<Message> findByToUserId(int userId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT m.*, u.real_name AS from_user_name FROM message m " +
            "LEFT JOIN user u ON m.from_user_id=u.id WHERE m.to_user_id=? ORDER BY m.create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rowToMsg(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    private Message rowToMsg(ResultSet rs) throws SQLException {
        Message m = new Message();
        m.setId(rs.getInt("id"));
        m.setItemId(rs.getInt("item_id"));
        m.setFromUserId(rs.getInt("from_user_id"));
        m.setToUserId(rs.getInt("to_user_id"));
        m.setContent(rs.getString("content"));
        m.setIsRead(rs.getInt("is_read"));
        m.setCreateTime(rs.getTimestamp("create_time"));
        try { m.setFromUserName(rs.getString("from_user_name")); } catch (SQLException ignored) {}
        return m;
    }
}
