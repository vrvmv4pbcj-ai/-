package com.foundlost.dao;

import com.foundlost.bean.Item;
import com.foundlost.util.DBUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDao {

    public int countByType(int type) {
        String sql = "SELECT COUNT(*) FROM item WHERE type=? AND is_deleted=0 AND status=1";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Item> findByPage(int offset, int pageSize, Integer type, Integer categoryId, String keyword) {
        List<Item> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT i.*, c.name AS category_name, u.real_name AS user_name " +
            "FROM item i LEFT JOIN category c ON i.category_id=c.id LEFT JOIN user u ON i.user_id=u.id " +
            "WHERE i.is_deleted=0 AND i.status=1 ");
        List<Object> params = new ArrayList<>();

        if (type != null) { sql.append("AND i.type=? "); params.add(type); }
        if (categoryId != null) { sql.append("AND i.category_id=? "); params.add(categoryId); }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND i.title LIKE ? ");
            params.add("%" + keyword + "%");
        }
        sql.append("ORDER BY i.create_time DESC LIMIT ?,?");
        params.add(offset);
        params.add(pageSize);

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rowToItem(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalCount(Integer type, Integer categoryId, String keyword) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM item i WHERE i.is_deleted=0 AND i.status=1 ");
        List<Object> params = new ArrayList<>();

        if (type != null) { sql.append("AND i.type=? "); params.add(type); }
        if (categoryId != null) { sql.append("AND i.category_id=? "); params.add(categoryId); }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND i.title LIKE ? ");
            params.add("%" + keyword + "%");
        }

        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public Item findById(int id) {
        String sql = "SELECT i.*, c.name AS category_name, u.real_name AS user_name " +
            "FROM item i LEFT JOIN category c ON i.category_id=c.id LEFT JOIN user u ON i.user_id=u.id " +
            "WHERE i.id=? AND i.is_deleted=0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rowToItem(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean insert(Item item) {
        String sql = "INSERT INTO item(title,type,category_id,description,image,location,item_date,contact_name,contact_phone,user_id) " +
            "VALUES(?,?,?,?,?,?,?,?,?,?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getTitle());
            ps.setInt(2, item.getType());
            ps.setInt(3, item.getCategoryId());
            ps.setString(4, item.getDescription());
            ps.setString(5, item.getImage());
            ps.setString(6, item.getLocation());
            ps.setDate(7, item.getItemDate() != null ? new java.sql.Date(item.getItemDate().getTime()) : null);
            ps.setString(8, item.getContactName());
            ps.setString(9, item.getContactPhone());
            ps.setInt(10, item.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(int id, int status) {
        String sql = "UPDATE item SET status=? WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean softDelete(int id) {
        String sql = "UPDATE item SET is_deleted=1 WHERE id=?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<Item> findByUserId(int userId, int offset, int pageSize) {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name FROM item i LEFT JOIN category c ON i.category_id=c.id " +
            "WHERE i.user_id=? AND i.is_deleted=0 ORDER BY i.create_time DESC LIMIT ?,?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rowToItem(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getCountByUserId(int userId) {
        String sql = "SELECT COUNT(*) FROM item WHERE user_id=? AND is_deleted=0";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<Item> findAuditPage(int offset, int pageSize) {
        List<Item> list = new ArrayList<>();
        String sql = "SELECT i.*, c.name AS category_name, u.real_name AS user_name " +
            "FROM item i LEFT JOIN category c ON i.category_id=c.id LEFT JOIN user u ON i.user_id=u.id " +
            "WHERE i.is_deleted=0 ORDER BY i.status ASC, i.create_time DESC LIMIT ?,?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(rowToItem(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int getAuditTotalCount() {
        String sql = "SELECT COUNT(*) FROM item WHERE is_deleted=0";
        try (Connection conn = DBUtil.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    private Item rowToItem(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setId(rs.getInt("id"));
        item.setTitle(rs.getString("title"));
        item.setType(rs.getInt("type"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setDescription(rs.getString("description"));
        item.setImage(rs.getString("image"));
        item.setLocation(rs.getString("location"));
        item.setItemDate(rs.getDate("item_date"));
        item.setContactName(rs.getString("contact_name"));
        item.setContactPhone(rs.getString("contact_phone"));
        item.setUserId(rs.getInt("user_id"));
        item.setStatus(rs.getInt("status"));
        item.setIsDeleted(rs.getInt("is_deleted"));
        item.setCreateTime(rs.getTimestamp("create_time"));
        try { item.setCategoryName(rs.getString("category_name")); } catch (SQLException ignored) {}
        try { item.setUserName(rs.getString("user_name")); } catch (SQLException ignored) {}
        return item;
    }
}
