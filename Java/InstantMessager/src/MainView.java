import javax.swing.*;
import java.net.Socket;

public class MainView {
    JFrame mainFrame;
    JTabbedPane chatTab;
    public MainModel mm;
    public ServerView sv;
    public ClientView cv;

    public MainView (MainModel _mm) {
        mm = _mm;
        mainFrame = new JFrame("Instant Messager");
        mainFrame.setSize(800,800);
        mainFrame.setResizable(false);
        chatTab = new JTabbedPane();
        chatTab.setSize(600,600);
        mainFrame.add(chatTab);
        if(mm.serverMode) {
            sv = new ServerView(mm.sm);
        }
        if(mm.clientMode) {
            cv = new ClientView(mm.cm);
            chatTab.add("TMPAAAAAAAAAAAAAAAAA", cv.chatPanel);
        }
        mainFrame.pack();
        mainFrame.setVisible(true);
    }


}
