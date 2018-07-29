public class Fysiker extends Human implements Comparable<Human> {
	private int year;

	private static boolean check(int year, int age) {
		if ((year < 1932) || (year > 2013)) {
			//System.out.println("1");
			return false;
		} else if (age - (2014 - year) < 15) {
			//System.out.println(age + " " + year);
			return false;
		} else
			return true;
	}

	// Static av samma anledning till klass Human.
	private static int slumpYear() {
        return (int) ((Math.random() * (2014 - 1932)) + 1932);
	}

	public Fysiker(int ageIn, String nameIn, int yearIn) {
		super(ageIn, nameIn);
		if (!check(yearIn, ageIn)) {
			System.err.println("Fel på input av året man börja eller ålden.");
			System.exit(0);
		}
		year = yearIn;
	}

	private static int slumpFysikerAge(int year) {
		int tmpAge = slumpAge();
		while (check(year, tmpAge)) {
			tmpAge = slumpAge();
		}
		return tmpAge;
	}

	public int getYear() {
        return this.year;
	}

	public Fysiker() {
		year = slumpYear();
		age = slumpFysikerAge(year);
		name = slumpName();
	}

	public String toString() {
        return "namn: " + name + ", ålder " + age + " år, läser i årskurs F" + String.format("%02d", this.year%100);
	}

    public int compareTo(Fysiker o) {
        if (this.age < o.age)
            return -1;
        else if(this.age > o.age)
            return 1;
        else {
            if (this.getYear() < o.getYear()) return -1;
            else if (this.getYear() > o.getYear()) return 1;
            else return 0;
        }
    }
}
