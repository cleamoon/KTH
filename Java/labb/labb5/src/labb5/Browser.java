package labb5;

import javax.swing.*;
import javax.swing.event.HyperlinkEvent;
import javax.swing.event.HyperlinkListener;
import javax.swing.text.html.HTMLEditorKit;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.LinkedList;

/** A very simple java browser
 *
 *
 */
public class Browser extends JFrame implements HyperlinkListener, ActionListener {
    private JButton backButton;
    private JButton forwardButton;
    private JButton historyButton;
    private JTextField addressBar;
    private JEditorPane mainFrame;
    private JPanel menu;
    private LinkedList<URL> history;
    private LinkedList<URL> his;
    private int top = -1;
    private int curr = -1;


    /** The constructor that starts everything.
     *
     * @throws IOException
     */
    public Browser() throws IOException {
		backButton = new JButton ("Backward");
		forwardButton = new JButton ("Forward");
		historyButton = new JButton ("History");
		addressBar = new JTextField(80);
		history = new LinkedList<URL>();
		his = new LinkedList<>();
		menu = new JPanel();
		menu.add(backButton);
		menu.add(forwardButton);
		menu.add(historyButton);
		menu.add(addressBar);
		menu.setComponentOrientation(ComponentOrientation.LEFT_TO_RIGHT);
        HTMLEditorKit kit = new HTMLEditorKit();
        mainFrame = new JEditorPane();
        mainFrame.setEditable(false);
        mainFrame.setEditorKit(kit);
        JScrollPane scrollPane = new JScrollPane(mainFrame);
        backButton.addActionListener(this);
        forwardButton.addActionListener(this);
        historyButton.addActionListener(this);
        addressBar.addActionListener(this);
        mainFrame.addHyperlinkListener(this);
        Container c = getContentPane();
        c.add(menu, BorderLayout.NORTH);
        c.add(scrollPane, BorderLayout.CENTER);
        setTitle("Java browser");
        setSize(1280,800);
        setMinimumSize(new Dimension(1280,800));
        setVisible(true);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        // mainFrame.setPage(new URL("http://www.kth.se"));
        // history.add(new URL("http://www.kth.se"));
        colorChange(0);
    }

    /** Check if a link is clicked
     *
     * @param e
     */
    @Override
    public void hyperlinkUpdate(HyperlinkEvent e) {
        if (e.getEventType() == HyperlinkEvent.EventType.ACTIVATED) try {
            URL url = format(e.getURL().toString());
            mainFrame.setPage(url);
            if (curr == top) {
                history.add(url);
                curr = curr + 1;
                top = top + 1;
                his.add(url);
            } else {
                curr = curr + 1;
                history.set(curr, url);
                his.add(url);
            }
        } catch (MalformedURLException e1) {
            e1.printStackTrace();
        } catch (IOException e1) {
            e1.printStackTrace();
        }
    }

    /** Change the color of the buttons
     *
     * @param s - different states
     */
    public void colorChange(int s) {
        if (s==0) {
            backButton.setForeground(Color.gray);
            forwardButton.setForeground(Color.gray);
        } else if (s==1) {
            backButton.setForeground(Color.gray);
            forwardButton.setForeground(Color.black);
        } else if (s==2) {
            backButton.setForeground(Color.black);
            forwardButton.setForeground(Color.gray);
        } else {
            backButton.setForeground(Color.black);
            forwardButton.setForeground(Color.black);
        }
    }

    /** Check if a button is pressed
     *
     * @param e
     */
    public void actionPerformed(ActionEvent e) {
        if(e.getSource()==backButton) {
            if(curr != 0) {
                curr = curr-1;
                URL url = history.get(curr);
                try {
                    mainFrame.setPage(url);
                } catch (IOException e1) {
                    showError("No previous site");
                }
            } else {
                showError("No previous site");
            }
            if(curr == 0) {
                if(top == 0) {
                    colorChange(0);
                } else {
                    colorChange(1);
                }
            } else {
                colorChange(3);
            }
        } else if(e.getSource() == forwardButton) {
            if(curr != top) {
                curr = curr + 1;
                URL url = history.get(curr);
                try {
                    mainFrame.setPage(url);
                } catch (IOException e1) {
                    showError("No next site");
                }
            } else {
                showError("No next site");
            }
            if(curr == top) {
                if(top == 0) {
                    colorChange(0);
                } else {
                    colorChange(2);
                }
            } else {
                colorChange(3);
            }
        } else if(e.getSource() == addressBar) {
            try {
                URL url = format(addressBar.getText());
                HttpURLConnection huc =  ( HttpURLConnection )  url.openConnection ();
                huc.setRequestMethod ("GET");
                huc.connect () ;
                int code = huc.getResponseCode() ;
                if (code == 404) throw new IOException();
                mainFrame.setPage(url);
                his.add(url);
                if (curr != top) {
                    curr = curr + 1;
                    history.set(curr, url);
                } else {
                    history.add(url);
                    curr = curr + 1;
                    top = top + 1;
                }
                if (curr == 0) {
                    if(top == curr) {
                        colorChange(0);
                    } else {
                        colorChange(1);
                    }
                } else if (curr == top) {
                    if(curr == 0) {
                        colorChange(0);
                    } else {
                        colorChange(2);
                    }
                } else {
                    colorChange(3);
                }
            } catch (IOException e1) {
                showError("Page Not Found");
            }
        } else if(e.getSource() == historyButton) {
            File f = new File("history.html");
            BufferedWriter bw = null;
            try {
                bw = new BufferedWriter(new FileWriter(f));
                bw.write("<html>");
                bw.write("<body>");
                bw.write("<h1>Browsing history</h1>");
                String line;
                int i=0;
                while (i != his.size()) {
                    bw.write("<p> <a href=\"" + his.get(i).toString() + "\" >" + his.get(i).toString() + "</a> </p>");
                    bw.newLine();
                    i = i+1;
                }
                bw.write("</body>");
                bw.write("</html>");
                bw.close();
                mainFrame.setPage(String.valueOf(f.toURI()));
            } catch (IOException e1) {
                e1.printStackTrace();
            }
        }
    }

    /** Show the error windows
     *
     * @param str
     */
    private void showError(String str) {
        JOptionPane.showMessageDialog(this, str, "Error",JOptionPane.WARNING_MESSAGE);
    }

    /** Start the constructor
     *
     * @param argc
     * @throws IOException
     */
    public static void main(String[] argc) throws IOException {
        Browser B  = new Browser();
    }

    /** Format the url to be correct
     *
     * @param str
     * @return
     * @throws MalformedURLException
     */
    private URL format(String str) throws MalformedURLException {
        if(!str.startsWith("http://www.")) {
            str = "http://www." + str;
        } else if (!str.startsWith("http://")) {
            str = "http://" + str;
        }
        return new URL(str);
    }
}
