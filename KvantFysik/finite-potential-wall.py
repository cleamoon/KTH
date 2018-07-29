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

EeV = -4.92051252
#EeV = -4.68246978          
#EeV = -4.28721919
E = EeV*e          # input energy in J

V0 = 5.0*e

# potential energy function
def V(x):
    y = 0.0
    if (abs(x)<a) : y = -V0
    return y

# initial values and lists
x = -2.0*a             # initial value of position x
psi = 0.0           # wave function at initial position
dpsi = 1.0          # derivative of wave function at initial position
x_tab = []          # list to store positions for plot
psi_tab = []        # list to store wave function for plot
x_tab.append(x)
psi_tab.append(psi)
#v_tab = []
#v_tab.append(0.0)

for i in range(N*4) :
    #v_tab.append(V(x))
    d2psi = c*(V(x)-E)*psi
    d2psinew = c*(V(x+dx)-E)*psi
    psi += dpsi*dx + 0.5*d2psi*dx2
    dpsi += 0.5*(d2psi+d2psinew)*dx
    x += dx
    x_tab.append(x)
    psi_tab.append(psi)

print 'E=',EeV,'eV , psi(x=2a)=',psi

plt.figure(num=None, figsize=(8,8), dpi=80, facecolor='w', edgecolor='k')
plt.plot(x_tab, psi_tab, linewidth=1, color='red') 
#plt.plot(x_tab, v_tab, linewidth=1, color='blue') 
plt.xlabel('x')
plt.ylabel(r'$\psi$')
#plt.savefig('psi.pdf')
plt.show()

#solve equation sqrt(z0^2-z^2) = z*tanz
z02 = a*a*(2*m*V0)/hbar/hbar
upper = sqrt(1.0*e*2*m)/hbar*a
M = 1000
z_tab = np.linspace(0, upper, num=M, endpoint=False)
a_tab = sqrt(z02-np.power(z_tab, 2))
b_tab = z_tab * tan(z_tab)
plt.figure(num=None, figsize=(8,8), dpi=80, facecolor='w', edgecolor='k')
plt.plot(z_tab, a_tab, linewidth=1, color='blue')
plt.plot(z_tab, b_tab, linewidth=1, color='red')
plt.xlabel('z')
plt.ylabel(r'$(z_O^2-z^2)$')
plt.show()