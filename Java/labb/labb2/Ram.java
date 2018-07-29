import paket.MyButton;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Ram extends JFrame implements ActionListener{
    MyButton button = new MyButton();
    public Ram() {
        this.setBounds(300, 300, 500, 350);
        this.setLayout(new FlowLayout());
        button.addActionListener((ActionListener) this);
        this.add(button);
        // pack() funktionen ändrar programmets layout så det passar.
        this.pack();
        // Så programmet kan synas.
        this.setVisible(true);
        // Utan det slutar programmet aldrig.
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
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
