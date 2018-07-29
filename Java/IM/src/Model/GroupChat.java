package Model;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;

public class GroupChat {
    private ConnectionList cl;
    private MessageList ml;

    public GroupChat(Socket s) throws IOException {
        cl = new ConnectionList();
        ml = new MessageList();
        cl.append(new Connection(s));
    }

    public void incomingMessage(Message m, int incomingIndex) throws Exception {
        ml.append(m);
        broadcast(m, incomingIndex);
    }

    public void outgoingMessage(Message m) throws Exception {
        ml.append(m);
        broadcast(m);
    }

    public void broadcast(Message m) throws Exception {
        for(int i=0; i<cl.size(); i++) {
            cl.get(i).getOut().println(m.getFormatText());
        }
    }

    public void broadcast(Message m, int incomingIndex) throws Exception {
        for(int i=0; i<cl.size(); i++) {
            if(i != incomingIndex) {
                cl.get(i).getOut().println(m.getFormatText());
            }
        }
    }

    public int disconnect() throws Exception {
        for (int i=0; i<cl.size(); i++) {
            cl.get(i).close();
        }
        return 0;
    }
}
