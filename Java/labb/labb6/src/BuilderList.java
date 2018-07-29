import com.oracle.webservices.internal.api.databinding.Databinding;

public class BuilderList {
    private element root = null;
    private int length = 0;
    private int[] list = null;
    public class element{
        private element next = null;
        private element prev = null;
        private int data = 0;
    }
    public BuilderList() {
        length = 0;
    }

    public void add(int index, int value) {
        if(index == 0 && root == null) {
            root = new element();
            root.data = value;
            root.next = null;
            root.prev = null;
            length += 1;
            return;
        }
        element it = root;
        for (int i = 0; i < index-1; i++)
            it = it.next;
        if (it.next != null) {
            it.next.prev = new element();
            it.next.prev.data = value;
            it.next.prev.prev = it;
            it.next.prev.next = it.next;
            it.next = it.next.prev;
        } else {
            it.next = new element();
            it.next.data = value;
            it.next.prev = it;
            it.next.next = null;
        }
        length += 1;
    }
    public int get(int index) {
        if (list == null) {
            list = new int[length];
            element it = root;
            for (int i = 0; i < length; i++) {
                list[i] = it.data;
                it = it.next;
            }
        }
        return list[index];
    }
}
