package Model;

import java.io.*;
import java.net.Socket;

public class Connection {
    private Socket socket;
    private BufferedReader in;
    private PrintWriter out;
    private String name;
    private int id;


    public Connection(Socket socket, String name) throws IOException {
        this.socket = socket;
        this.in = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        this.out = new PrintWriter(socket.getOutputStream(), true);
        this.name = name;
    }

    public void close () throws IOException {
        socket.close();
    }

    public Socket getSocket() {
        return socket;
    }

    public BufferedReader getIn() {
        return this.in;
    }

    public PrintWriter getOut() {
        return this.out;
    }

    public String getName() {
        return this.name;
    }

    public void setName(String str) {
        this.name = str;
    }

    public int getId() {
        return this.id;
    }

    public void setId(int id) {
        this.id = id;
    }
}