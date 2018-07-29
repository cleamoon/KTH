import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;

public class ServerModel {
    public int port;
    public boolean isGroupChat = false;
    public ArrayList<ClientModel.Connection> groupChatList;
    public ServerSocket serverSocket;
    public String name;

    public ServerModel (int _port, String _name) throws IOException {
        this.port = _port;
        this.name = _name;
        serverSocket = new ServerSocket(port);
    }

}
