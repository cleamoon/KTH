import Model.ConnectionList;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;

public class Model implements Runnable{
    private Model.ConnectionList connectionList;
    private int n = 0;
    private Model.GroupChat groupChat;
    private ServerSocket listener;
    private boolean groupChat = false;
    private int port;

    public Model(int port) throws IOException {
        this.port = port;
        connectionList = new ConnectionList();
        listener = new ServerSocket(port);
    }

    @Override
    public void run() {
        while(true) {
            try{
                if(connectionList.size() != n) {

                }
            }
            catch (Exception e) {
                System.err.println(e.getStackTrace());
                System.err.println(e.getCause().toString());
                break;
            }
        }
    }
}
