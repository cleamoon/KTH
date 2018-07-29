import Model.StylePackage;
import Model.*;
import View.CheckDialog;

import java.awt.*;

public class Test {
    public static void main(String[] args) throws Exception {

        // Message format testing
        String str = "Hello world. <text>, \" /&/ \' -> 你好";
        StylePackage sp = new StylePackage(Color.magenta, false, true);
        Message m = new Message(str, sp);
        System.out.println(str);
        System.out.println(m.getEscText());
        System.out.println(m.getFormatText());
        System.out.println(m.getEncText());

        // Cryptography testing
        System.out.println(Cryptography.encryptCaesar(m.getEncText(), 3));
        System.out.println(Cryptography.decryptCaesar(Cryptography.encryptCaesar(m.getEncText(), 3), 3));
        String sk = "my_key";
        System.out.println(Cryptography.encryptBlowfish(m.getEncText(), sk));
        String des =  Cryptography.encryptBlowfish(m.getEncText(), sk);
        System.out.println(Cryptography.decryptBlowfish(des, sk));
        System.out.println(Message.decode(Cryptography.decryptBlowfish(des, sk)));
        System.out.println(Cryptography.encryptAES(m.getEncText(), sk));
        String des2 =  Cryptography.encryptAES(m.getEncText(), sk);
        System.out.println(Cryptography.decryptAES(des2, sk));
        System.out.println(Message.decode(Cryptography.decryptAES(des2, sk)));


        // Check dialog testing
        CheckDialog cd = new CheckDialog("Do you agree?", "Yes", "Definitely YES");
        int r = cd.showDialog();
        System.out.println("The result is ");
        System.out.println(r);

        // Styled document testing
        /*
        JTextPane textPane = new JTextPane();
        StyledDocument doc = textPane.getStyledDocument();

        Style style1 = textPane.addStyle("I'm a Style", null);
        Style style2 = textPane.addStyle("I'm another style", null);
        StyleConstants.setForeground(style1, Color.red);
        StyleConstants.setForeground(style2, Color.magenta);

        try { doc.insertString(doc.getLength(), "BLAH ",style1); }
        catch (BadLocationException e){}

        //StyleConstants.setForeground(style, Color.blue);

        try { doc.insertString(doc.getLength(), "BLEH",style2); }
        catch (BadLocationException e){}

        JFrame frame = new JFrame("Test");
        frame.getContentPane().add(textPane);
        frame.pack();
        frame.setVisible(true);
        */
        cd.dispose();
        return;
    }
}