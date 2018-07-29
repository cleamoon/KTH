package Model;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.Socket;

public class Chat {
    private Connection con;
    private MessageList ml;
    private int id;

    public Chat(Socket socket) throws IOException {
        this.con = new Connection(socket);
        ml = new MessageList();
    }

    public void incomingMessage(Message m) {
        ml.append(m);
    }

    public void outgoingMessage(Message m) {
        ml.append(m);
        PrintWriter out = con.getOut();
        out.println(m.getFormatText());
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getId() {
        return this.id;
    }

    public int disconnect() throws IOException {
        con.close();
        return 0;
    }
}
