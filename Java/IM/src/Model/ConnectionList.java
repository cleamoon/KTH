package Model;

import java.util.ArrayList;

public class ConnectionList {
    private ArrayList<Connection> cl;

    public ConnectionList() {
        cl = new ArrayList<Connection>();
    }

    public void append(Connection c) {
        cl.add(c);
    }

    public void remove(int i) {
        cl.remove(i);
    }

    public boolean exist(Connection c) {
        for(int i=0; i < cl.size(); i++) {
            if (c == cl.get(i)) {
                return true;
            }
        }
        return false;
    }

    public int find(Connection c) {
        for(int i=0; i < cl.size(); i++) {
            if(c == cl.get(i)) {
                return i;
            }
        }
        return cl.size()+1;
    }

    public int size(){
        return cl.size();
    }

    public Connection get(int i) throws Exception {
        if(i < 0 || i>=cl.size()) {
            throw new Exception("Index out of range");
        }
        return cl.get(i);
    }
}
