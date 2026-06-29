package com.foundlost.util;

import java.util.List;

public class PageBean<T> {
    private int pageNum;       // 当前页
    private int pageSize;      // 每页条数
    private int totalCount;    // 总记录数
    private int totalPage;     // 总页数
    private List<T> list;      // 当前页数据

    public PageBean(int pageNum, int pageSize, int totalCount) {
        this.pageNum = pageNum;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.totalPage = (int) Math.ceil(totalCount * 1.0 / pageSize);
    }

    public int getPageNum()    { return pageNum; }
    public int getPageSize()   { return pageSize; }
    public int getTotalCount() { return totalCount; }
    public int getTotalPage()  { return totalPage; }
    public List<T> getList()   { return list; }
    public void setList(List<T> list) { this.list = list; }
}
