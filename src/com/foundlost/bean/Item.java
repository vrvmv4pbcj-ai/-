package com.foundlost.bean;

import java.util.Date;

public class Item {
    private int id;
    private String title;
    private int type;          // 0寻物 1招领
    private int categoryId;
    private String categoryName; // 联查用
    private String description;
    private String image;
    private String location;
    private Date itemDate;
    private String contactName;
    private String contactPhone;
    private int userId;
    private String userName;     // 联查用
    private int status;          // 0待审核 1已发布 2已下架 3已找到/已归还
    private int isDeleted;
    private Date createTime;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public int getType() { return type; }
    public void setType(int type) { this.type = type; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getCategoryName() { return categoryName; }
    public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }
    public Date getItemDate() { return itemDate; }
    public void setItemDate(Date itemDate) { this.itemDate = itemDate; }
    public String getContactName() { return contactName; }
    public void setContactName(String contactName) { this.contactName = contactName; }
    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public int getIsDeleted() { return isDeleted; }
    public void setIsDeleted(int isDeleted) { this.isDeleted = isDeleted; }
    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
}
