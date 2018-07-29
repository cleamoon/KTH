import java.net.ServerSocket;

public class ServerController implements Runnable{
    public ServerModel sm;
    public ServerView sv;

    public ServerController (ServerModel _sm, ServerView _sv) {
        this.sm = _sm;
        this.sv = _sv;
    }

    @Override
    public void run() {
        try {
            ClientModel.Connection con = new ClientModel.Connection(sm.serverSocket.accept(), "tmp");
            while (true) {
                con.out.println("name " + sm.name);
                con.username = con.in.readLine();
                if (con.username == null ||con.username.contains(" ")) { throw new Exception("Illegal username"); }
                //synchronized (sm.groupChatList) { sm.groupChatList.add(con); }
                break;
            }
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }
}
