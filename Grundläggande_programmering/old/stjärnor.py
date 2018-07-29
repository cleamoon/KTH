# /usr/bin/python

def rektangel (tom, rader, kolumn, ch):
    for i in range(rader):
        print(' '*tom + ch*kolumn)

def ram (rader, kolumn, size, ch):
    for i in range(size):
        print (ch*kolumn)
    for i in range(rader-2*size):
        print (ch*size + (kolumn-2*size)*' ' + ch*size)
    for i in range(size):
        print (ch*kolumn)

def triangelBasUpp(tom, bas):
    string = ""        
    for i in range (0, (bas+1)//2):
        string += ' '*tom + ' '*i + (bas-i*2)*'*' + '\n'
    return string
        
def triangelBasNed(tom, bas):
    string = ""
    for i in range (1, bas+2, 2):
        string += ' '*tom + (bas-i)//2*' ' + i*'*' + '\n'
    return string
        
def romb(tom, storlek):
    return (triangelBasNed(tom, storlek) + triangelBasUpp((tom+1), (storlek-2)))
        
def main():
    ctrl = input("Skriva vad du vill visa: 1 för rektangel, 2 för ram, 3 för triangel med bas upp, 4 för triagel med bas ned, 5 för en romb\n")
    if ctrl == '1':
        tom = int(input("Hur stor tomt plats vill du har:"))
        rader = int(input("Hur långa rader vill du har:"))
        kolumn = int(input("Hur långa kolumn vill du har:"))
        ch = input("Vilken tecken vill du skriva ut:")
        rektangel (tom, rader, kolumn, ch)
    elif ctrl == '2':
        rader = int(input("Hur långa rader vill du har:"))
        kolumn = int(input("Hur långa kolumn vill du har:"))
        size = int(input("Hur bredd vill du har:"))
        ram (rader, kolumn, size, '*')
    elif ctrl == '3':
        tom = int(input("Hur stor tomt plats vill du har:"))
        bas = int(input("Hur stor bas vill du har:"))
        print(triangelBasUpp(tom, bas))
    elif ctrl == '4':
        tom = int(input("Hur stor tomt plats vill du har:"))
        bas = int(input("Hur stor bas vill du har:"))
        print(triangelBasNed(tom, bas))
    elif ctrl == '5':
        tom = int(input("Hur stor tomt plats vill du har:"))
        bas = int(input("Hur stor vill du att din romb ska vara:"))
        print(romb (tom, bas))
    else:
        print ("fel kommando")

if __name__ == "__main__":
    main()
