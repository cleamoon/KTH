package labb4;

import java.util.ArrayList;
import java.util.LinkedList;

import static java.lang.Math.abs;

public class Model {
    private int L;
    private boolean crystallization = false;
    public int length  = 800, width = 600;
    private boolean[][] map = new boolean[length][width];
    private LinkedList<Particle> lpar = new LinkedList<Particle>();   // Particles
    private LinkedList<Particle> apar = new LinkedList<Particle>();  // Moving particles
    private LinkedList<Particle> dpar = new LinkedList<Particle>();  // Frozen particles
    private LinkedList<Particle> rpar = new LinkedList<Particle>();   // Particle to freeze
    private LinkedList<int[]> lpos = new LinkedList<int[]>();    // Positions
    private LinkedList<int[]> apos = new LinkedList<int[]>();   // Alive positions
    private LinkedList<int[]> dpos = new LinkedList<int[]>();   // Dead positions

    private class Particle{
		private int[] pos = new int[2];

		public Particle(int x, int y) { this.pos[0] = x; this.pos[1] = y;}
		public Particle() {	this((int)(Math.random()*length),(int)(Math.random()*width));}

		public int getx(){	return this.pos[0];}
		public int gety(){	return this.pos[1];}
		public int[] getPos(){ return this.pos;}
        public void move(double angle){
            this.pos[0] += (int)Math.round(getL() * Math.cos(angle));
            this.pos[1] += (int)Math.round(getL() * Math.sin(angle));
        }
	}

	public Model(int N, int L){
		setL(L);
		for(int n=0; n < N; n++) {
			Particle tmp = new Particle();
			lpar.add(tmp);
			apar.add(tmp);
		}
	}

    public boolean isCollide(int[] pos){
	    int x = pos[0];
	    int y = pos[1];
        int circle = 200;
        if (crystallization)
            return (x <= 1 || x >= length-2 || y <= 1 || y >= width-2 || map[x][y] ||
                    abs((x-length/2)*(x-length/2) + (y-width/2)*(y-width/2) - circle*circle) < 3);
        return false;
    }

	public void moveAll(){
		rpar.clear();
		for(Particle p: apar){
		    int x = p.getx();
		    int y = p.gety();
            if( isCollide(p.getPos())) {
                for (int xi = (x - 2); xi <= (x + 2); xi++)
                    for (int yi = (y - 2); yi <= (y + 2); yi++)
                        if (xi >= 0 && xi < length && yi >= 0 && yi < width) map[xi][yi] = true;
                dpar.add(p); rpar.add(p);
            } else {
                p.move(Math.random() * ( 2 * Math.PI ));
            }
		}
		for(Particle p: rpar) apar.remove(p);
	}
	
	public LinkedList<int[]> getallPos(){
		lpos.clear();
		for(Particle p: lpar) lpos.add(p.getPos());
		return lpos;
	}
	public LinkedList<int[]> getalivePos(){
		apos.clear();
		for(Particle p: apar) apos.add(p.getPos());
		return apos;
	}
	public LinkedList<int[]> getdeadPos(){
		dpos.clear();
		for(Particle p: dpar) dpos.add(p.getPos());
		return dpos;
	}
	public void setL(int L){ this.L = L;}
	public int getL(){ return L;}
	public void changeCrystallization(){ crystallization = !crystallization;}
	
}