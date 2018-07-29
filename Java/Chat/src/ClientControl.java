import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class ClientControl implements Runnable{
    public ClientModel cm;
    public UserInterface ui;

    public ClientControl(ClientModel _cm, UserInterface _ui) {
        cm = _cm;
        ui = _ui;
        ui.show();
        ui.textField.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                cm.out.println(ui.textField.getText());
                ui.textField.setText("");
            }
        });
    }

    @Override
    public void run() {
        try {
            ui.frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            ui.frame.setVisible(true);
            String serverAddress = ui.getServerAddress();
            Socket socket = new Socket(serverAddress, ui.getPort());
            cm.in = new BufferedReader(new InputStreamReader(
                    socket.getInputStream()));
            cm.out = new PrintWriter(socket.getOutputStream(), true);
            ui.textField.setVisible(true);

            while (true) {
                String line = cm.in.readLine();
                if (line.startsWith("SUBMITNAME")) {
                    cm.out.println(ui.getUsername());
                } else if (line.startsWith("NAMECCEPTED")) {
                    System.err.println("start talking");
                    ui.textField.setEditable(true);
                } else if (line.startsWith("MESSAGE")) {
                    ui.messageArea.append(line.substring(8) + "\n");
                }
            }
        }
        catch (Exception e) {
            System.err.println(e.getStackTrace());
        }

    }
}

