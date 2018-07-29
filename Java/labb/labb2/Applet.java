import paket.MyButton;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Applet extends JApplet implements ActionListener{
    MyButton button = new MyButton();
    public Applet() {
        this.setLayout(new FlowLayout());
        button.addActionListener((ActionListener) this);
        this.add(button);
    }
    public static void main(String[] args) {
        new Ram();
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == button) {
            button.toggleState();
        }
    }
}
