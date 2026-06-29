package com.foundlost.bean;

public class Category {
    private int id;
    private String name;
    private int sortOrder;
    private int status;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getSortOrder() { return sortOrder; }
    public void setSortOrder(int sortOrder) { this.sortOrder = sortOrder; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
}
