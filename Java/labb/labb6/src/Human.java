public abstract class Human implements Comparable<Human> {
    protected int age;
    protected String name;

    public Human (int ageIn, String nameIn) {
        this.age = ageIn;
        this.name = nameIn;
    }

    // Två slump funktionerna är static för att de tillhör klassen inte objekt.
    // Så de kan kallas utan objekt skapas.
    protected static String slumpName() {
        String[] nameList= {"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o"};
        int whichName = (int) (Math.random()*nameList.length);
        return nameList[whichName];
    }

    protected static int slumpAge() {
        return (int) (Math.random()*100);
    }

    // Den kallar den andra kontruktor.
    protected Human() {
        this(slumpAge(), slumpName());
    }

    public int getAge() {
        return this.age;
    }

    public String getName() {
        return this.name;
    }

    public String toString() {
        return "namn: " + this.getName() + ", ålder " + this.getAge() + " år";
    }

    public	static Human create(String name, String year, int age){
        int y = Integer.parseInt(year.substring(1,3))+2000;
        if (year.startsWith("F")) return Fysiker.init(age, name, y);
        else return Datalog.init(age, name, y);
    }

    @Override
    public int compareTo(Human o) {
        if (this.age < o.age)
            return -1;
        else if(this.age > o.age)
            return 1;
        else if((o instanceof Fysiker)&&(this instanceof Fysiker)) {
            return ((Fysiker)this).compareTo((Fysiker)o);
        }
        else{
            return 0;
        }
    }
}