import javax.swing.*;
import javax.swing.tree.*;
import java.io.*;
import java.awt.*;
import java.awt.event.*;
import java.util.Scanner;

public class DirTree extends JFrame implements ActionListener {

    private JCheckBox box;
    private JTree tree;
    // private DefaultMutableTreeNode root;
    private MyNode root;
    private DefaultTreeModel treeModel;
    private JPanel controls;
    private static String katalog=".";
    private static final String closeString = " Close ";
    private static final String showString = " Show Details ";
    private Scanner sc = this.fileScan();
    private String sline = sc.nextLine();

    public DirTree() {
        Container c = getContentPane();
        //*** Build the tree and a mouse listener to handle clicks
        // root = new DefaultMutableTreeNode(katalog);
        root = readNode();
        // buildTree();
        treeModel = new DefaultTreeModel( root );
        tree = new JTree( treeModel );
        MouseListener ml =
                new MouseAdapter() {
                    public void mouseClicked( MouseEvent e ) {
                        if ( box.isSelected() )
                            showDetails( tree.getPathForLocation( e.getX(), e.getY() ) );
                    }
                };
        tree.addMouseListener( ml );
        //*** build the tree by adding the nodes
        //buildTree();
        //*** panel the JFrame to hold controls and the tree
        controls = new JPanel();
        box = new JCheckBox( showString );
        init(); //** set colors, fonts, etc. and add buttons
        c.add( controls, BorderLayout.NORTH );
        c.add( tree, BorderLayout.CENTER );
        setVisible( true ); //** display the framed window
    }

    public void actionPerformed( ActionEvent e ) {
        String cmd = e.getActionCommand();
        if ( cmd.equals( closeString ) )
            dispose();
    }

    private void init() {
        tree.setFont( new Font( "Dialog", Font.BOLD, 12 ) );
        controls.add( box );
        addButton( closeString );
        controls.setBackground( Color.lightGray );
        controls.setLayout( new FlowLayout() );
        setSize( 400, 400 );
    }

    private void addButton( String n ) {
        JButton b = new JButton( n );
        b.setFont( new Font( "Dialog", Font.BOLD, 12 ) );
        b.addActionListener( this );
        controls.add( b );
    }

    private void buildTree() {
        /*File f=new File(katalog);
        String[] list = f.list();
        for (int i=0; i<list.length; i++ )
            buildTree(new File(f,list[ i ]), root);*/
        /*
        root = new DefaultMutableTreeNode();
        DefaultMutableTreeNode växter = new DefaultMutableTreeNode();
        DefaultMutableTreeNode djur = new DefaultMutableTreeNode();
        DefaultMutableTreeNode svampar = new DefaultMutableTreeNode();
        root.add(växter);
        root.add(djur);
        root.add(svampar);*/
    }

    private void buildTree( File f, DefaultMutableTreeNode parent) {
        DefaultMutableTreeNode child = new DefaultMutableTreeNode( f.toString() );
        parent.add(child);
        if ( f.isDirectory() ) {
            String list[] = f.list();
            for ( int i = 0; i < list.length; i++ )
                buildTree( new File(f,list[i]), child);
        }
    }

    private Scanner fileScan() {
        Scanner sc = null;
        try {
            sc = new Scanner(new BufferedReader(new FileReader("./src/Liv.xml")));
            sc.nextLine();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        return sc;
    }

    private MyNode readNode() {
        String text = null;
        String level = null;
        String name = null;
        MyNode retNode = null;

        if (sc.hasNextLine()) {
            try {
                String[] aline = sline.split("> ");
                level = aline[0].split(" namn=")[0];
                name = aline[0].split(" namn=")[1];
                text = aline[1];
                int nco = 0;
                for(int i=0; i<sline.length(); i++) {
                    if('\"' == sline.charAt(i)) nco += 1;
                }
                if (nco != 2 && nco != 4) {
                    //System.out.println(nco);
                    throw new Exception();
                }
                if(!level.startsWith("<") | !name.startsWith("\"") | !name.endsWith("\"")) {
                    throw new Exception();
                } else {
                    level = level.substring(1);
                    name = name.substring(1, name.length() -1);
                }
            } catch (Exception e) {
                System.err.println("Parse fel");
                System.exit(1);
            }
            retNode = new MyNode(level, name, text);
            sline = sc.nextLine();
            while (!sline.startsWith("</")){
                retNode.add(readNode());
                sline = sc.nextLine();
            }
        }
        return retNode;
    }

    private String detailGen(MyNode n, TreePath p) {
        String s = n.getName() + ": " + n.getText() + "\n";
        MyNode[] an = new MyNode[p.getPath().length];
        for(int i=0; i<p.getPath().length; i += 1) {
            an[i] = (MyNode) p.getPath()[i];
        }
        if (an.length != 1) {
            s += "Men allt som är ";
        }
        for(int i=an.length-1; i>=0; i -= 1) {
            s += an[i];
            if(i!=0) s += " är ";
        }
        s += "\n";
        return s;
    }

    private void showDetails( TreePath p ) {
        if ( p == null ) return;
        /*File f = new File( p.getLastPathComponent().toString() );
        JOptionPane.showMessageDialog( this, f.getPath() +
                "\n   " +
                getAttributes( f ) );*/
        MyNode n = (MyNode) p.getLastPathComponent();
        JOptionPane.showMessageDialog(this, detailGen(n, p));
    }

    private String getAttributes( File f ) {
        String t = "";
        if ( f.isDirectory() )
            t += "Directory";
        else
            t += "Nondirectory file";
        t += "\n   ";
        if ( !f.canRead() )
            t += "not ";
        t += "Readable\n   ";
        if ( !f.canWrite() )
            t += "not ";
        t += "Writeable\n  ";
        if ( !f.isDirectory() )
            t += "Size in bytes: " + f.length() + "\n   ";
        else {
            t += "Contains files: \n     ";
            String[ ] contents = f.list();
            for ( int i = 0; i < contents.length; i++ )
                t += contents[ i ] + ", ";
            t += "\n";
        }
        return t;
    }

    public static void main( String[ ] args ) {
        if(args.length>0) katalog=args[0];
        new DirTree();
    }


}
