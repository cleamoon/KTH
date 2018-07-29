import javax.swing.text.BadLocationException;
import javax.swing.text.Document;
import javax.swing.text.SimpleAttributeSet;
import javax.swing.text.StyledDocument;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.util.ArrayList;

public class ClientController implements Runnable{
    ClientView cv;
    ClientModel cm;

    public ClientController (ClientModel _cm, ClientView _cv) {
        this.cv = _cv;
        this.cm = _cm;
        cv.inputPane.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                String inputString = cv.inputPane.getText();
                cv.displayPane.append( cm.con.username + ": " + inputString+"\n" );
                cv.inputPane.setText("");
                cm.con.out.println(inputString);
            }
        });
    }

    @Override
    public void run() {
        while(true) {
            try {
                String conLineInput = cm.con.in.readLine();
                if(conLineInput.startsWith("name ")) {
                    System.out.println(cm.con.username);
                    cm.con.out.println(cm.con.username);
                } else {
                    cv.displayPane.append(conLineInput + "\n");
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}