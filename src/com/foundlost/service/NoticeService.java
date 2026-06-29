package com.foundlost.service;

import com.foundlost.bean.Notice;
import com.foundlost.dao.NoticeDao;
import java.util.List;

public class NoticeService {
    private NoticeDao dao = new NoticeDao();

    public List<Notice> findAll() { return dao.findAll(); }
    public List<Notice> findByPage(int pageNum, int pageSize) {
        return dao.findByPage((pageNum-1)*pageSize, pageSize);
    }
    public int getTotalCount() { return dao.getTotalCount(); }
    public boolean add(Notice n) { return dao.insert(n); }
    public boolean delete(int id) { return dao.delete(id); }
    public boolean updateStatus(int id, int status) { return dao.updateStatus(id, status); }
}