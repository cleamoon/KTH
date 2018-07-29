import javax.swing.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.PrintWriter;

public class UserInterface {
    public JFrame frame;
    public JTextField textField;
    public JTextArea messageArea;

    public UserInterface(PrintWriter out) {
        frame = new JFrame("Chatter");
        textField = new JTextField(40);
        messageArea = new JTextArea(8, 40);
        textField.setEditable(true);
        messageArea.setEditable(false);
        frame.getContentPane().add(textField, "North");
        frame.getContentPane().add(new JScrollPane(messageArea), "Center");

    }

    public String getServerAddress() {
        return JOptionPane.showInputDialog(
                frame,
                "Enter IP Address of the Server:",
                "Welcome to the Chatter",
                JOptionPane.QUESTION_MESSAGE);
    }

    public String getUsername() {
        return JOptionPane.showInputDialog(
                frame,
                "Choose a screen name:",
                "Screen name selection",
                JOptionPane.PLAIN_MESSAGE);
    }

    public int getPort(){
        return Integer.parseInt(JOptionPane.showInputDialog(
                frame,
                "Choose a port to start with:",
                "Server port selection",
                JOptionPane.PLAIN_MESSAGE));
    }

    public void show() {
        frame.pack();
    }

}
