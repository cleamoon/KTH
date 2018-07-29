import java.net.Socket;

public class MainController implements Runnable{
    public MainView mv;
    public MainModel mm;
    public ServerController sc;
    public ClientController cc;

    public MainController(MainModel _mm, MainView _mv) {
        mv = _mv;
        mm = _mm;
        if(mm.serverMode) {
            sc = new ServerController(mm.sm, mv.sv);
        }
        if(mm.clientMode) {
            cc = new ClientController(mm.cm, mv.cv);
        }
    }

    public void run() {
        if(mm.serverMode) {
            (new Thread(sc)).start();
        }
        if(mm.clientMode) {
            (new Thread(cc)).start();
        }
    }
}
