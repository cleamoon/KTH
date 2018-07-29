import javax.swing.tree.DefaultMutableTreeNode;

/**
 * Created by yueji on 2017-03-04.
 */
public class MyNode extends DefaultMutableTreeNode{
    private String level;
    private String name;
    private String text;
    private int nChild = 0;

    public MyNode (String level, String name, String text) {
        this.level = level;
        this.name = name;
        this.text = text;
        this.userObject = this.name;
    }

    public String getlevel() {
        return this.level;
    }

    public String getText() {
        return this.text;
    }

    public String getName() {
        return this.name;
    }

    public void add(MyNode n) {
        this.nChild += 1;
        super.add(n);
    }
}
