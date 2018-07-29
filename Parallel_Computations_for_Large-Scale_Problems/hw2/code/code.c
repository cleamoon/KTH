#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <mpi.h>
#define MIN(a,b) ((a) < (b) ? (a) : (b))
#define PI 3.1415926535897
#define N 1000  
#define SMX 10000000

inline double r(double x) {
    return -x*x;
}

inline double f(double x) {
    return x*x*sin(PI*x) - PI*PI*sin(PI*x);
}

int main(int argc, char *argv[])
{
    int rc, P, p;
    MPI_Status* status;
    status = (MPI_Status *) malloc (sizeof(MPI_Status));
	
    rc = MPI_Init(&argc, &argv);
    rc = MPI_Comm_size(MPI_COMM_WORLD, &P);
    rc = MPI_Comm_rank(MPI_COMM_WORLD, &p);
    if (N < P) {
	fprintf(stdout, "Too few discretization points...\n");
	exit(1);
    }
    
    int L = N/P;
    int R = N%P;
    int I = (N+P-p-1)/P;
    double h = 1.0/(N+1.0);
    double *rr, *ff, *unew, *u;
    rr = (double *) malloc ((N+2)*sizeof(double));
    ff = (double *) malloc ((N+2)*sizeof(double));
    unew = (double *) malloc(I*sizeof(double));
    u = (double *) calloc(I+2, sizeof(double));
    
    for(int i=0; i<N+2; i++) {
	rr[i] = r(((double)i)*h); 
	ff[i] = f(((double)i)*h);
	//printf("i: %d, rr: %F, ff: %F\n", i, rr[i], ff[i]);
    }

    for (int step = 0; step < SMX; step++) {
	if (p%2) {
	    if (p+1 != P) {
		rc = MPI_Send(unew + I - 1, 1, MPI_DOUBLE, p+1, 0, MPI_COMM_WORLD);
		rc = MPI_Recv(u + I + 1, 1, MPI_DOUBLE, p+1, 0, MPI_COMM_WORLD, status);
	    }
	    if (0 != p) {
		rc = MPI_Send(unew + 0, 1, MPI_DOUBLE, p-1, 0, MPI_COMM_WORLD);
		rc = MPI_Recv(u + 0, 1, MPI_DOUBLE, p-1, 0, MPI_COMM_WORLD, status);
	    }
	} else {
	    if (0 != p) {
		rc = MPI_Recv(u + 0, 1, MPI_DOUBLE, p-1, 0, MPI_COMM_WORLD, status);
		rc = MPI_Send(unew + 0, 1, MPI_DOUBLE, p-1, 0, MPI_COMM_WORLD);
	    }
	    if (p+1 != P) {
		rc = MPI_Recv(u + I + 1, 1, MPI_DOUBLE, p+1, 0, MPI_COMM_WORLD, status);
		rc = MPI_Send(unew + I - 1, 1, MPI_DOUBLE, p+1, 0, MPI_COMM_WORLD);
	    }
	}
	for(int i = 0; i < I; i++) {
	    int n = p*L + MIN(p,R) + i + 1;
	    unew[i] = (u[i]+u[i+2]-h*h*ff[n])/(2.0-h*h*rr[n]);
	}
	for(int i=0; i < I; i++) {
	    u[i+1] = unew[i];
	}
    }

    int* signal;
    signal = (int*) malloc (sizeof(int));
    int tmp;
	
    MPI_Barrier(MPI_COMM_WORLD);
    printf("done computing\n");

    if (p == 0) {
	FILE* file = fopen("res.txt", "a");
	for(int i = 0; i < I; i++) {
	    fprintf(file, "%F\n", unew[i]);
	}
	fclose(file); 
	tmp = 1;
	rc = MPI_Send(&tmp, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
    } else {
	rc = MPI_Recv(signal, 1, MPI_INT, p-1, 0, MPI_COMM_WORLD, status);
	if(*signal == p) {
	    FILE* file = fopen("res.txt", "a");
	    for(int i = 0; i < I; i++) {
		fprintf(file, "%.8F\n", unew[i]);
	    }
	    fclose(file); 
	    if(p!=P-1) {
		tmp = p+1;
		rc = MPI_Send(&tmp, 1, MPI_INT, p+1, 0, MPI_COMM_WORLD);
	    }
	}
    }
	
    MPI_Finalize();
    return 0;
}
