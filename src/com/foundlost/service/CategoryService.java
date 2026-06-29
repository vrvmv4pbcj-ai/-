package com.foundlost.service;

import com.foundlost.bean.Category;
import com.foundlost.dao.CategoryDao;
import java.util.List;

public class CategoryService {
    private CategoryDao dao = new CategoryDao();

    public List<Category> findAll() { return dao.findAll(); }
    public Category findById(int id) { return dao.findById(id); }
    public List<Category> findByPage(int pageNum, int pageSize) {
        return dao.findByPage((pageNum-1)*pageSize, pageSize);
    }
    public int getTotalCount() { return dao.getTotalCount(); }
    public boolean add(Category cat) { return dao.add(cat); }
    public boolean delete(int id) { return dao.delete(id); }
    public boolean updateStatus(int id, int status) { return dao.updateStatus(id, status); }
}