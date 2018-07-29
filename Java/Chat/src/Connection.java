import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class Connection implements Runnable {
    public Socket socket;
    public String username;
    public BufferedReader in;
    public PrintWriter out;

    public Connection(Socket socket, String username) throws IOException {
        this.socket = socket;
        this.in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        this.out = new PrintWriter(socket.getOutputStream(), true);
        this.username = username;
    }

    @Override
    public void run() {
        while (true) {
            try {
                String input = in.readLine();
                if (input == null) {
                    return;
                }
                out.println("MESSAGE " + username + ": " + input);
            } catch (Exception e) {
                System.err.println(e.getStackTrace());
            } finally {
                try {
                    socket.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
