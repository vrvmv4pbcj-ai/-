package com.foundlost.dao;

import com.foundlost.bean.Notice;
import com.foundlost.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NoticeDao {

    public List<Notice> findAll() {
        List<Notice> list = new ArrayList<>();
        String sql = "SELECT * FROM notice WHERE status=1 ORDER BY create_time DESC";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(rowToNotice(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Notice> findByPage(int offset, int pageSize) {
        List<Notice> list = new ArrayList<>();
        String sql = "SELECT * FROM notice ORDER BY create_time DESC LIMIT ?,?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rowToNotice(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM notice";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean insert(Notice n) {
        String sql = "INSERT INTO notice(title,content,user_id) VALUES(?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, n.getTitle());
            ps.setString(2, n.getContent());
            ps.setInt(3, n.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "UPDATE notice SET status=0 WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(int id, int status) {
        String sql = "UPDATE notice SET status=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Notice rowToNotice(ResultSet rs) throws SQLException {
        Notice n = new Notice();
        n.setId(rs.getInt("id"));
        n.setTitle(rs.getString("title"));
        n.setContent(rs.getString("content"));
        n.setUserId(rs.getInt("user_id"));
        n.setStatus(rs.getInt("status"));
        n.setCreateTime(rs.getTimestamp("create_time"));
        return n;
    }
}