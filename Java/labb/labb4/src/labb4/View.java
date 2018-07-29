package labb4;

import java.awt.*;
import javax.swing.JPanel;

public class View extends JPanel{
	
	private Model m;
	
	public View(Model model){
		this.m = model;
		this.setPreferredSize(new Dimension(m.length,m.width));
	}
	
	@Override
	public void paint(Graphics g){
		super.paintComponent(g);
		g.setColor(Color.blue);
		g.fillRect(0,0,m.length,m.width);
		g.setColor(Color.yellow);
		for(int[] pos : m.getalivePos()){ g.fillOval(pos[0], pos[1], 2, 3);}
		g.setColor(Color.red);
		for(int[] pos : m.getdeadPos()){ g.fillOval(pos[0], pos[1], 2, 3);}
	}
	
	public void update(){ repaint(); }
}
