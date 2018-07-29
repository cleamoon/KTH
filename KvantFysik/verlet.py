# -*- coding: utf-8 -*-
# Python simulation of an electron in an infinite potential well
# MW 150926

from pylab import *
import numpy as np
import matplotlib.pyplot as plt

a=1.0e-9           # well width a=1 nm
hbar=1.0546e-34    # Plancks constant
m=9.1094e-31       # electron mass
e=1.6022e-19       # electron charge=-e
c=2.0*m/hbar**2    # constant in Schrödinger equation
N=10000            # number of mesh points
dx=a/(N+1.0)       # step length
dx2=dx**2          # step length squared

EeV = 0.376          # input energy in eV: test 0.3 , 0.4 , 0.3760 , 1.5
E = EeV*e          # input energy in J

print 'E1=',(hbar*np.pi/a)**2/(2.0*m)/e,'eV'
print 'E2=',(hbar*2.0*np.pi/a)**2/(2.0*m)/e,'eV'

# potential energy function
def V(x):
    y = 0.0
    #if (abs(x)<a) : y = -V0
    return y

# initial values and lists
x = 0.0             # initial value of position x
psi = 0.0           # wave function at initial position
dpsi = 1.0          # derivative of wave function at initial position
x_tab = []          # list to store positions for plot
psi_tab = []        # list to store wave function for plot
x_tab.append(x)
psi_tab.append(psi)

for i in range(N) :
    d2psi = c*(V(x)-E)*psi
    d2psinew = c*(V(x+dx)-E)*psi
    psi += dpsi*dx + 0.5*d2psi*dx2
    dpsi += 0.5*(d2psi+d2psinew)*dx
    x += dx
    x_tab.append(x)
    psi_tab.append(psi)

print 'E=',EeV,'eV , psi(x=a)=',psi

plt.figure(num=None, figsize=(8,8), dpi=80, facecolor='w', edgecolor='k')
plt.plot(x_tab, psi_tab, linewidth=1, color='red') 
plt.xlabel('x')
plt.ylabel(r'$\psi$')
#plt.savefig('psi.pdf')
plt.show()

