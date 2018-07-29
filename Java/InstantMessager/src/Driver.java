import java.io.IOException;

public class Driver {
    public static void main (String[] args) throws IOException {
        MainModel mm = new MainModel();
        MainView mv = new MainView(mm);
        MainController mc = new MainController(mm, mv);
        (new Thread(mc)).start();
    }
}
