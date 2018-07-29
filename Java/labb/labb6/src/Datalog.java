import javax.xml.crypto.Data;

public class Datalog extends Human {
    private int year;

    private Datalog(int ageIn, String nameIn, int yearIn) {
        super(ageIn, nameIn);
        this.year = yearIn;
    }

    public static Datalog init(int ageIn, String nameIn, int yearIn) {
        return new Datalog(ageIn, nameIn, yearIn);
    }

    public String toString() {
        return "namn: " + name + ", ålder " + age + " år, läser i data, år " + String.format("%02d", year);
    }

}
