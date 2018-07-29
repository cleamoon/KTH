import bintree2

t = bintree2.Bintree();

l = [12,3,332,22,3,31,3,4,456,4,5,6,6,3,52214,31,4,1,3,2];

t.put_list(l);

t.delete_data(2);
print(t.printtree());
t.delete_data(3);
print(t.printtree());
t.delete_data(22);
print(t.printtree());
t.delete_data(456);
print(t.printtree());
t.delete_data(52214);
print(t.printtree());
