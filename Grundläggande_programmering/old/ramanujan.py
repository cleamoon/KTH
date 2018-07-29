# /usr/bin/python
import math

def rakna_summa ():
    ### räkna summa
    print ("Skriva a och b")
    a = int(input())
    b = int(input())
    sum = a**3 + b**3
    print (sum)

    
def is_cubic ( give_me_a_better_name ):
    ### is cubic
#    print (give_me_a_better_name, round(give_me_a_better_name**(1./3))**3)
    if (give_me_a_better_name == round(give_me_a_better_name**(1./3))**3):
        return True
    else:
        return False

        
def rakna_a_och_b ():
    ### räkna a och b
    print ("Skriva summan")
    sum = int(input())
    resultat = []
    cubic_rot = round(sum**(1./3))
    if (sum%2 == 1):
        for a in range (1, cubic_rot, 2):
#            print (a)
            if (is_cubic ( sum - a**3 )):
                resultat.append( (a, round((sum-a**3)**(1./3))) )
    else:
        for a in range (1, cubic_rot, 1):
#            print (a)
            if (is_cubic ( sum - a**3 )):
                resultat.append( (a, round((sum-a**3)**(1./3))) )
    print (resultat)

def main():
    ### driv funktion
    while True:
        print ("Välja vad du vill göra: ")
        print ("1 för räkna summa, 2 för räkna a och b")
        ctrl = input()
        if(ctrl == "1"):
            rakna_summa()
            break
        elif (ctrl == "2"):
            rakna_a_och_b()
            break
        else:
            print ("Var snäll och välja en rätt kommando")

if __name__ == "__main__":
    main()


