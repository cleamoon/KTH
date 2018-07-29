import javax.swing.*;
import java.awt.*;

public class ClientView {
    JPanel chatPanel;
    JTextArea displayPane;
    JTextField inputPane;
    public ClientModel cm;

    public ClientView(ClientModel _cm) {
        cm = _cm;
        chatPanel = new JPanel();
        chatPanel.setLayout(new BorderLayout());
        chatPanel.setPreferredSize(new Dimension(600,600));
        displayPane = new JTextArea();
        displayPane.setSize(600, 500);
        displayPane.setEditable(false);
        inputPane = new JTextField();
        inputPane.setSize(600,100);
        inputPane.setEditable(true);

        chatPanel.add(displayPane, BorderLayout.NORTH);
        chatPanel.add(inputPane, BorderLayout.SOUTH);
    }
}
