import java.util.ArrayList;
import java.util.LinkedList;

public class Client {
	
	public static void main(String[] args){
		Composite bigBag = new Composite("bigBag", 10); //Root
		Composite mediumBag1 = new Composite("mediumBag1", 5);
		Composite mediumBag2 = new Composite("mediumBag2", 5);
		Composite smallBag1 = new Composite("smallBag1", 1);
		Composite smallBag2 = new Composite("smallBag2", 2);
		Composite item1 = new Composite("item1", 1);
		Composite item2 = new Composite("item2", 2);
		Composite item3 = new Composite("item3", 3);
		Composite item4 = new Composite("item4", 4);

		smallBag1.add(item1);
		smallBag2.add(item2);
		mediumBag1.add(smallBag1);
		mediumBag1.add(item3);
		mediumBag2.add(smallBag2);
		mediumBag1.add(item4);
		bigBag.add(mediumBag1);
		bigBag.add(mediumBag2);

		Composite bigBag2 = bigBag.clone();
		Composite item5 = new Composite("heave", 100);
		bigBag2.add(item5);

		System.out.println(bigBag.toString());
		System.out.println(bigBag.getWeight());

		System.out.println(bigBag2.toString());
		System.out.println(bigBag2.getWeight());

		System.out.println(Human.create("A","F10",22).toString());
		System.out.println(Human.create("B","D11",21).toString());
		System.out.println(Human.create("C","D12",20).toString());

		// Human h = new Human(20, "H");
		// Fysiker f = new Fysiker(20,"A", 18);
		// Datalog d = new Datalog(20,"B", 18);

		long starttime = System.currentTimeMillis();
		// LinkedList<Integer>  myList = new LinkedList<Integer>();
		ArrayList<Integer> myList = new ArrayList<Integer>();
		// BuilderList myList = new BuilderList();
		int sum = 0;
		for(int i=0; i<100000; i++)
			myList.add(0, i);
		for(int i=0; i<100000; i++)
			sum += myList.get(i);
		System.out.println(sum);
		long stoptime = System.currentTimeMillis();
		System.out.println("");
		System.out.println(stoptime-starttime);

	}
}
