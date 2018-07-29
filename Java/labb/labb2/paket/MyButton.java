package paket;

import javax.swing.*;
import java.awt.*;

public class MyButton extends JButton{
    private Color col1, col2;
    private String text1, text2;

    public MyButton(Color col1, Color col2, String text1, String text2) {
        this.col1 = col1;
        this.text1 = text1;
        this.col2 = col2;
        this.text2 = text2;
        this.setBackground(col1);
        this.setText(text1);
    }
    public MyButton() {
        this(Color.white, Color.yellow, "Default 1", "Default 2");
    }
    public void toggleState() {
        Color tC;
        String tS;
        tC = this.col1;
        this.col1 = this.col2;
        this.col2 = tC;
        tS = this.text1;
        this.text1 = this.text2;
        this.text2 = tS;
        //System.out.println(text1 + text2);
        this.setBackground(col1);
        this.setText(text1);
    }

}
