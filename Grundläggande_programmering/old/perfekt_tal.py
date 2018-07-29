# /usr/bin/python

def funktion ( number ):
#    number = int(input())
    if(number%2==1):
        return False
    else:
        binary = bin(number)[2:]
#        print (binary)
        length = len(binary)
        is_right = True
        for x in range (0, length//2+1):
            if (binary[x] != '1'):
                return False
        for x in range (length//2+1, length):
            if (binary[x] != '0'):
                return False
        return True

def main():
    for x in range (1, 1000):
        if(funktion(x)):
            print (x, "är perfekt")
#        else:
 #           print (x, "är inte perfekt")

if __name__ == "__main__":
    main()
