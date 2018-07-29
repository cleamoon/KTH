package View;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class CheckDialog extends JDialog {
    Frame mf = new Frame("Permission requirement");
    Panel submitP = new Panel();
    private Button bYes;
    private Button bNo;
    public int result;

    public CheckDialog(String description, String yesDescription, String noDescription) {
        setResizable(false);
        getContentPane().setLayout(new SpringLayout());
        Label des = new Label();
        des.setText(description);
        mf.setSize(300,200);
        mf.setLayout(new GridLayout(2,1));

        bYes = new Button(yesDescription);
        bNo = new Button(noDescription);
        bYes.addActionListener(new buttonClickListener());
        bNo.addActionListener(new buttonClickListener());
        submitP.add(bYes);
        submitP.add(bNo);

        mf.add(des);
        mf.add(submitP);
    }

    private class buttonClickListener implements ActionListener{
        @Override
        public void actionPerformed(ActionEvent actionEvent) {
            if(actionEvent.getSource() == bYes) {
                result = 1;
            } else {
                result = 0;
            }
            mf.dispose();
        }
    }

    public int showDialog() {
        mf.setVisible(true);
        return result;
    }
}
