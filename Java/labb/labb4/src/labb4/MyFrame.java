package labb4;

import java.io.IOException;

public class MyFrame{
    public static void main(String[] args) throws IOException {
        Model model = new Model(1000,1);
        View view = new View(model);
        Controller controller = new Controller(model, view);
        controller.showUI();
    }
}