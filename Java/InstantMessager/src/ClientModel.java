import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class ClientModel {
    public Connection con;

    public ClientModel(Connection _con) throws IOException {
        this.con = _con;
    }

    public static class Connection {
        public Socket socket;
        public BufferedReader in;
        public PrintWriter out;
        public String username;

        public Connection(Socket _socket, String _username) throws IOException {
            this.socket = _socket;
            this.in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
            this.out = new PrintWriter(socket.getOutputStream(), true);
            this.username = _username;
        }
    }
}
