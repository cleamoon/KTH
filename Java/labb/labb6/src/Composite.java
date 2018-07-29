import java.util.ArrayList;
import java.util.Iterator;

public class Composite extends Component {
	
	private ArrayList<Composite> items = new ArrayList<Composite>();
	private int head = 0;
	
	public Composite(String name, double weight) {
		this.name = name;
		this.weight = weight;
	}
	
	public void add(Composite item){
		items.add(item);
	}
	
	public void remove(Composite item){
		items.remove(item);
	}
	
	public Composite getChild(int index){
		return items.get(index);
		}
	
	public String toString(){
		ArrayList<String> tmp = new ArrayList<String>();
		for (Composite i: items) {
			tmp.add(i.toString());
		}
		if (tmp.isEmpty())
            return name;
		else
		    return name + " contains " + tmp.toString();
		
	}

	public double getWeight() {
		for (Component i: items) {
			weight += i.getWeight();
		}
		return weight;
	}

	@Override
	public boolean hasNext() {
		if (head == items.size())
			return false;
		else
			return true;
	}

	@Override
	public Object next() {
		head += 1;
		return items.get(head - 1);
	}

	public Composite clone() {
	    Composite tmp = new Composite(this.name, this.weight);
	    for(Composite i : items) {
	        Composite tmpi = i.clone();
	        tmp.add(tmpi);
        }
        return tmp;
    }

    public Iterator<Composite> iterator() {
        return this;
    }

}
