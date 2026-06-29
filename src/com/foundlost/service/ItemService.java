package com.foundlost.service;

import com.foundlost.bean.Item;
import com.foundlost.dao.ItemDao;
import com.foundlost.util.PageBean;
import java.util.List;

public class ItemService {
    private ItemDao dao = new ItemDao();

    public int countByType(int type) { return dao.countByType(type); }

    public PageBean<Item> findByPage(int pageNum, int pageSize, Integer type, Integer categoryId, String keyword) {
        int total = dao.getTotalCount(type, categoryId, keyword);
        PageBean<Item> pb = new PageBean<>(pageNum, pageSize, total);
        int offset = (pageNum - 1) * pageSize;
        pb.setList(dao.findByPage(offset, pageSize, type, categoryId, keyword));
        return pb;
    }

    public Item findById(int id) { return dao.findById(id); }
    public boolean publish(Item item) { return dao.insert(item); }
    public boolean offline(int id) { return dao.updateStatus(id, 2); }
    public boolean softDelete(int id) { return dao.softDelete(id); }

    public PageBean<Item> findMyItems(int userId, int pageNum, int pageSize) {
        int total = dao.getCountByUserId(userId);
        PageBean<Item> pb = new PageBean<>(pageNum, pageSize, total);
        pb.setList(dao.findByUserId(userId, (pageNum-1)*pageSize, pageSize));
        return pb;
    }

    public PageBean<Item> findAuditPage(int pageNum, int pageSize) {
        int total = dao.getAuditTotalCount();
        PageBean<Item> pb = new PageBean<>(pageNum, pageSize, total);
        pb.setList(dao.findAuditPage((pageNum-1)*pageSize, pageSize));
        return pb;
    }

    public boolean audit(int id, int status) { return dao.updateStatus(id, status); }
}
