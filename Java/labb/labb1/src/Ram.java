import java.util.Arrays;
import java.util.List;

import static sun.misc.Version.println;

public class Ram {
    public static void main (String[] args) {
        // E2
        System.out.println("E2:");
        Human putte = new Human (25, "Putte");
        System.out.println(putte);


        // E3
        System.out.println("\nE3");
        for (int i=0; i<15; i++) {
            Human slu = new Human();
            System.out.println(slu);
        }


        // E4
        System.out.println("\nE4");
        //Fysiker Newton = new Fysiker(50, "Newton", 1800);
        for (int i=0; i<15; i++) {
            Fysiker slu = new Fysiker();
            System.out.println(slu.toString());
        }
        System.out.println("\n");
        for (int i=0; i<5; i++) {
            Human slu = new Human();
            System.out.println(slu.toString());
        }
        System.out.println("\n");
        for (int i=0; i<5; i++) {
            Fysiker slu = new Fysiker();
            System.out.println(slu.toString());
        }

        // E5
        System.out.println("\nE5");
        Human a = new Human();
        Human b = new Human();
        System.out.println(a.toString());
        System.out.println(b.toString());
        if(a.compareTo(b)==1) {
            System.out.println(b.name + ", som är " + b.age + " år är yngre än " + a.name + 
                ", som är " + a.age + " år");
        }
        else if(a.compareTo(b)==-1) {
            System.out.println(a.name + ", som är " + a.age + " år är yngre än " + b.name + 
                ", som är " + b.age + " år");

        }
        else {
            System.out.println(a.name + ", som är " + a.age + " år är lika gammal som " + b.name);
        }
        Human[] f;
        int n = 10;
        f = new Human[n];
        for(int i=0; i<n/2; i++) {
            f[i] = new Human();
        }
        for(int i=n/2; i<n; i++) {
            f[i] = new Fysiker();
        }
        Arrays.sort(f);
        for(int i=0; i<n; i++) {
            System.out.println(f[i]);
        }


        // C del
        System.out.println("C del");
        Human[] ini;
        int nini = 0;
        if(args.length>0) {
            /*for(String s: args)
                System.out.println(s);*/
            ini = new Human[args.length];
            for(int i=2; i<args.length; i++) {
                switch(args[i]) {
                    case "-H":
                        ini[nini] = new Human(Integer.parseInt(args[i+2]), args[i+1]);
                        i += 2;
                        nini += 1;
                        break;
                    case "-F":
                        int y = Integer.parseInt(args[i+3]);
                        if(y < 16) y += 2000;
                        else y += 1900;
                        ini[nini] = new Fysiker(Integer.parseInt(args[i+2]), args[i+1], y);
                        i += 2;
                        nini += 1;
                        break;
                    default:
                        break;
                }
            }
            for(int i=0; i<nini; i++) {
                System.out.println(ini[i]);
            }
        }
    }
}
