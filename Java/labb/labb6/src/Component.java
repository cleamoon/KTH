import java.util.Iterator;

public abstract class Component implements Iterator {
	
	protected String name;
	protected double weight;
	
	@Override
	public abstract String toString();

	public abstract double getWeight();
}