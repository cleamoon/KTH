public class Chat {

    public static void main(String[] args) {
        try {
            ClientModel cm = new ClientModel();
            UserInterface ui = new UserInterface(cm.out);
            ServerControl sc = new ServerControl(ui);
            ClientControl cc = new ClientControl(cm, ui);
            (new Thread(cc)).start();
            (new Thread(sc)).start();
        } catch (Exception e) {
            System.err.println(e.getStackTrace());
        }
    }
}