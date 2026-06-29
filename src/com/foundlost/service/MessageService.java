package com.foundlost.service;

import com.foundlost.bean.Message;
import com.foundlost.dao.MessageDao;
import java.util.List;

public class MessageService {
    private MessageDao dao = new MessageDao();

    public boolean send(Message msg) { return dao.insert(msg); }
    public List<Message> findByItemId(int itemId) { return dao.findByItemId(itemId); }
    public List<Message> findMyMessages(int userId) { return dao.findByToUserId(userId); }
}
