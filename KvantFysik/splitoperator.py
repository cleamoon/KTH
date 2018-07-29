# -*- coding: utf-8 -*-
"""
Split Operator Method for simulating the time dependent Schrodinger equation
with real time animation

The code solves the time dependent SE, animates the solution, and stores the 
final frame in the file plot.png
The initial state is here a Gaussian wave packet.
Any potential can be investigated.

MW version 150927 
"""

import numpy as np
from matplotlib import pyplot as plt
from matplotlib import animation
from scipy.fftpack import fft,ifft,fftshift      # fast Fourier transforms
 
# set x-axis scale
N = 2**11    # choice suitable for fft
dx = 0.1
L = N*dx
x = dx*(np.arange(N)-0.5*N)

# set momentum scale
dk = 2*np.pi/L
k = -N*dk/2 + dk*np.arange(N)

# time parameters  
t = 0.0                         # start time
dt = 0.01                       # time step
tmax = 200.0                    # max time
nsteps = 50                     # number of time steps between frame updates
frames = int(tmax / float(nsteps * dt))
print frames

# parameters for potential barrier
w = 2.0                     # width of potential
V0 = 1.0                        # height of potential

# parameters for the initial gaussian wave packet
a = 4.0                         # width of gaussian
x0 = 0.0                      # initial center position
k0 = 2.0                        # initial center wave vector

# quantum parameters
hbar = 1.0
p = hbar*k 
m = 2.0

######################################################################
# Gaussian wave packet of width a, centered at x0, with momentum k0 
def gaussian(x, a, x0, k0):
    return ((a*np.sqrt(np.pi))**(-0.5)
            * np.exp(-0.5*((x-x0)*1./a)**2 + 1j*x*k0))
######################################################################
def theta(x):    # Heaviside function
    x = np.asarray(x)
    y = np.zeros(x.shape)
    y[x > 0] = 1.0
    return y
######################################################################
def potential(x):   # potential that can be selected to be any function
    pot = 0*x        # free particle
    #pot = V0*(theta(x+w/2.0)-theta(x-w/2.0))  # square barrier
    # hard wall boundary conditions    
    # commenting out the hard walls gives periodic boundary conditions
    #pot[x < -100] = 1e6   
    pot[x > 100] = 1e6
    return pot      
######################################################################

# Define arrays of potential energy and time evolution operators
pot = potential(x)     # potential energy
expV_half = np.exp(-1j*pot*dt/2/hbar)           # time evolution from potential energy
expV = expV_half*expV_half                   # time evolution from potential energy
expT = fftshift(np.exp(-1j*p*p*dt/(2*m)/hbar))  # time evolution from kinetic energy
# (fftshift stores the momenta in normal order, see the scipy documentation)

# calculate initial wave function
psi = gaussian(x,a,x0,k0)                    # initial wave packet

# set up the figure, the axis, and the plot element we want to animate
fig = plt.figure(figsize=(16,8),dpi=80)
ax1 = plt.subplot(111, autoscale_on=False, xlim=(-100.0,100.0), ylim=(0.0,0.2))
ax1.set_xlabel('x')
ax1.set_ylabel('$|\Psi(x,t)|^2$')
psi2_curve, = ax1.plot([], [], c='b')
potential_curve, = ax1.plot([], [], c='r')

# calculations
def step():
    global psi,t
    for it in range(nsteps) :              # don't plot all steps to speed up animation
        psi = ifft(expT*fft(expV*psi))     # one time step
        t = t+dt
    #print t
                                                                                                                
# initialization function: plot the background of each frame
def init():
    psi2_curve.set_data([], [])
    potential_curve.set_data([], [])
    return psi2_curve, potential_curve,

# animation function called sequentially
def animate(i):
    step() 
    psi2_curve.set_data(x, abs(psi)**2)
    potential_curve.set_data(x, pot/V0*0.05)
    return psi2_curve, potential_curve,

# call the animator.  blit=True means only re-draw the parts that have changed.
anim = animation.FuncAnimation(fig, animate, init_func=init,
                               frames=frames, interval=50, blit=True, repeat=False)

# save animation as gif file (works on Mac OS-X, not yet tested on Linux or Windows)
#anim.save('schrodingeranimation.gif', writer='imagemagick', fps=30);

plt.show()
#plt.savefig("./plot.png")             # store final frame



