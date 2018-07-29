import paket.MyButton;

import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

public class Inverse extends JFrame implements ActionListener{
    private static int n;
    private static MyButton[] ba;
    public Inverse() {
        this.setLayout(new FlowLayout());
        ba = new MyButton[n];
        for(int i=0; i<n; i++) {
            ba[i] = new MyButton(new Color((float)Math.random(), (float)Math.random(), (float)Math.random()),
                    new Color((float)Math.random(), (float)Math.random(), (float)Math.random()),
                    "Default Text "+(int)(Math.random()*100),
                    "Default Text "+(int)(Math.random()*100));
            this.add(ba[i]);
            ba[i].addActionListener((ActionListener) this);
        }
        this.pack();
        this.setVisible(true);
        this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    }
    public static void main(String[] args) {
        System.out.println(Math.random() +" "+ Math.random() +" "+ Math.random() +" "+ Math.random());
        if ((args==null)||(args.length==0))
            n = 1;
        else
            n = Integer.parseInt(args[0]);
        System.out.println(n);
        new Inverse();
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        for(int i=0; i<n; i++) {
            if (e.getSource() != ba[i]) {
                ba[i].toggleState();
            }
        }
    }
}
