All:
	mpicc -O2 -std=c11 code.c -o run -lm
	mpirun -np 16 run 1200
	octave oc.m
	rm res.txt


