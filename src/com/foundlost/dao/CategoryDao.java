package com.foundlost.dao;

import com.foundlost.bean.Category;
import com.foundlost.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDao {

    public List<Category> findAll() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM category WHERE status=1 ORDER BY sort_order";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) list.add(rowToCat(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public Category findById(int id) {
        String sql = "SELECT * FROM category WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rowToCat(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Category> findByPage(int offset, int pageSize) {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM category ORDER BY sort_order LIMIT ?,?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rowToCat(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalCount() {
        String sql = "SELECT COUNT(*) FROM category";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean add(Category cat) {
        String sql = "INSERT INTO category(name,sort_order) VALUES(?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, cat.getName());
            ps.setInt(2, cat.getSortOrder());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean delete(int id) {
        String sql = "UPDATE category SET status=0 WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(int id, int status) {
        String sql = "UPDATE category SET status=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Category rowToCat(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setId(rs.getInt("id"));
        c.setName(rs.getString("name"));
        c.setSortOrder(rs.getInt("sort_order"));
        c.setStatus(rs.getInt("status"));
        c.setCreateTime(rs.getTimestamp("create_time"));
        return c;
    }
}