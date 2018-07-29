package Model;

import java.util.ArrayList;

public class MessageList {
    public static final int MAX_MESSAGE_LIST_LENGTH = 1000;
    private ArrayList<Message> content = new ArrayList<>();

    public MessageList() {
    }

    public ArrayList<Message> getContaint() {
        return content;
    }

    public Message getContaint(int i) throws Exception {
        if (i<0 || i > content.size()) {
            throw new Exception("Index out of range.");
        } else {
            return content.get(i);
        }
    }

    public int append(Message m) {
        try {
            if (content.size() > MAX_MESSAGE_LIST_LENGTH) {
                content.remove(0);
            }
            content.add(m);
            return 0;
        } catch (Exception e) {
            System.err.println(e.getStackTrace());
            return 1;
        }
    }

    public int getLength() {
        return content.size();
    }

}
