import javax.swing.*;
import java.io.IOException;
import java.net.Socket;

public class MainModel {
    boolean serverMode = true;
    boolean clientMode = true;
    public ServerModel sm;
    public ClientModel cm;
    JFrame initFrame;

    public MainModel() throws IOException {
        initFrame = new JFrame();
        if(serverMode) {
            int port = getServerPort();
            sm = new ServerModel(port, "server_username");
        }
        if(clientMode) {
            String IP = getServerAddress();
            int port = getClientPort();
            String username = getUsername();
            ClientModel.Connection con = new ClientModel.Connection(new Socket(IP, port), username);
            System.out.println("here " + con.username);
            cm = new ClientModel(con);
        }
    }

    public String getServerAddress() {
        return JOptionPane.showInputDialog(
                initFrame,
                "Enter IP Address of the Server:",
                "Welcome to the Chatter",
                JOptionPane.QUESTION_MESSAGE);
    }

    public String getUsername() {
        return JOptionPane.showInputDialog(
                initFrame,
                "Choose a username:",
                "Username selection",
                JOptionPane.PLAIN_MESSAGE);
    }

    public int getServerPort(){
        return Integer.parseInt(JOptionPane.showInputDialog(
                initFrame,
                "Choose a port to start with:",
                "Server port selection",
                JOptionPane.PLAIN_MESSAGE));
    }

    public int getClientPort(){
        return Integer.parseInt(JOptionPane.showInputDialog(
                initFrame,
                "Choose a port to connect to:",
                "Server port selection",
                JOptionPane.PLAIN_MESSAGE));
    }
}
