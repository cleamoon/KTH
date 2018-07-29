package labb4;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.*;
import javax.swing.*;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;

public class Controller extends JPanel implements ChangeListener, ActionListener {
    private Timer timer;
    private int timeCounter = 0;
    private Model m;
    private View v;
    private JSlider LSlider;
    private JSlider deltaSlider;
	private MyButton memorize;
	private MyButton start;
	private MyButton freeze;
	private boolean doRecord = false;
	private FileWriter out = null;
	private int nline = 0;
	
	public Controller(Model m, View v) throws IOException {
        super(new BorderLayout());
        this.m = m;
		this.v = v;
        LSlider = new JSlider(JSlider.VERTICAL,	1, 10, m.getL());
		LSlider.setBackground(Color.black);
		LSlider.addChangeListener(this);
		LSlider.setMajorTickSpacing(1);
		LSlider.setPaintTicks(true);
		deltaSlider = new JSlider(JSlider.VERTICAL,	1, 100, 50);
		deltaSlider.setBackground(Color.black);
		deltaSlider.addChangeListener(this);
		deltaSlider.setMajorTickSpacing(10);
		deltaSlider.setPaintTicks(true);
		timer = new Timer(100, this);
		memorize  = new MyButton(Color.yellow, Color.black,"Start record","Stop record");
		start = new MyButton(Color.yellow, Color.black,"Start process","Stop process");
		freeze = new MyButton(Color.yellow, Color.black, "Enable crystallization", "Disable crystallization");
        out = new FileWriter("output.csv");
    }

    public void showUI(){
        JFrame mainFrame = new JFrame("Brown's movement");
        mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        mainFrame.getContentPane().add(v, BorderLayout.CENTER);
        JPanel sliderPanel = new JPanel();
        sliderPanel.setBackground(Color.black);
        sliderPanel.setLayout(new GridLayout(0,1));
        mainFrame.getContentPane().add(sliderPanel, BorderLayout.WEST);
        sliderPanel.add(LSlider);
        sliderPanel.add(deltaSlider);
        JPanel buttonsPanel = new JPanel();
        buttonsPanel.add(memorize);
        memorize.addActionListener(memorize);
        memorize.addActionListener(this);
        buttonsPanel.add(start);
        start.addActionListener(start);
        start.addActionListener(this);
        buttonsPanel.add(freeze);
        freeze.addActionListener(freeze);
        freeze.addActionListener(this);
        mainFrame.getContentPane().add(buttonsPanel, BorderLayout.SOUTH);
        buttonsPanel.setBackground(Color.darkGray);
        mainFrame.pack();
        mainFrame.setVisible(true);
    }

	public void stateChanged(ChangeEvent e){
		if(e.getSource()==LSlider){
			m.setL(LSlider.getValue());
		}
		if(e.getSource()==deltaSlider){
			timer.setDelay(110 - deltaSlider.getValue());
		}
	}

    public void write() throws IOException {
        try {
            out.write(Integer.toString(nline));
            for (int[] n : m.getallPos()) out.write("," + n[0] + "," + n[1]);
            out.write("\n\r");
            nline++;
        } finally {
            if(nline == 1000) out.close();
        }
    }

	public void actionPerformed(ActionEvent e){
		if(e.getSource().equals(timer)){
		    m.moveAll();
		    v.update();
            timeCounter += timer.getDelay();
            if(doRecord) try { write(); } catch (IOException ex) { }
		}
		if(e.getSource().equals(memorize)){
		    if(doRecord) try { out.close(); } catch (IOException ex) { }
		    doRecord = !doRecord;
		}
		if(e.getSource().equals(start)){ if(!timer.isRunning()){ timer.start(); } else { timer.stop(); } }
		if(e.getSource().equals(freeze)){ m.changeCrystallization(); }
	}
}