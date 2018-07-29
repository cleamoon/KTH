import bintree

t = bintree.Bintree();

l = [20,10,35,5,14,25,40,3,11,15,21,30,50,2,4,12,1000,1];

t.put_list(l);

print(t.printtree());

t.delete_data(12);
print(t.printtree());
t.delete_data(50);
print(t.printtree());
t.delete_data(35);
print(t.printtree());
t.delete_data(10);
print(t.printtree());

