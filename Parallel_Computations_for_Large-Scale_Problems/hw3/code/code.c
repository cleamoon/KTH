#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <stdbool.h>
#include <mpi.h>

int compare (const void * a, const void * b) {
  if ( *(double*)a <  *(double*)b ) return -1;
  if ( *(double*)a == *(double*)b ) return 0;
  if ( *(double*)a >  *(double*)b ) return 1;
}


int main(int argc, char **argv) {
    int N, P, p, I, tmp, rc;
    rc = MPI_Init(&argc, &argv);
    rc = MPI_Comm_size(MPI_COMM_WORLD, &P);
    rc = MPI_Comm_rank(MPI_COMM_WORLD, &p);
    /* Find problem size N from command line */
    if (argc < 2) {
	printf("No size N given");
	return 1;
    }
    N = atoi(argv[1]);
    /* local size. Modify if P does not divide N */
    I = N/P;
    /* random number generator initialization */
    srand(p+1);
    /* data generation */
    double *x, *a, *t;
    MPI_Status* status;
    int *signal;
    x = (double*) malloc (I*sizeof(double));
    a = (double*) malloc (I*sizeof(double));
    t = (double*) malloc (I*sizeof(double));
    signal = (int*) malloc (sizeof(int));
    for (int i = 0; i < I; i++) {
	x[i] = ((double) rand())/(RAND_MAX+1.0);
	a[i] = x[i];
    }
	
    qsort(a, I, sizeof(double), compare);

    if (P == 1) {
	FILE* file = fopen("res.txt", "a");
	for(int i = 0; i < I; i++) {
	    fprintf(file, "%F\n", a[i]);
	}
	MPI_Finalize();
	free(a);
	free(x);
	free(t);
	free(signal);
	return 0;
    }
    
    bool evenprocess = (p % 2 == 0);
    bool evenphase = 1;
    int sorted = 0;
    int global_sorted = 0;
    for (int step=0; step < N/2; step++) {
	rc = MPI_Barrier(MPI_COMM_WORLD);
	if((evenphase && evenprocess) || (!evenphase && !evenprocess)) {
	    // printf("Positive\n");
	    if (p+1 != P) {
		rc = MPI_Send(a, I, MPI_DOUBLE, p+1, 0, MPI_COMM_WORLD);
		rc = MPI_Recv(x, I, MPI_DOUBLE, p+1, 0, MPI_COMM_WORLD, status);
		if (a[I-1] <= x[0]) {
		    sorted = 1; 
		} else {
		    int m=0, n=0;
		    for(int i=0; i<I; i++) {
			if(a[m] > x[n]) {
			    t[i] = x[n];
			    n++;
			} else {
			    t[i] = a[m];
			    m++;
			}
		    }
		    for(int i=0; i<I; i++) {
			a[i] = t[i];
		    }
		    sorted = 0;
		}
	    } 
	} else {
	    // printf("Negative\n");
	    if (p != 0) {
		rc = MPI_Recv(x, I, MPI_DOUBLE, p-1, 0, MPI_COMM_WORLD, status);
		rc = MPI_Send(a, I, MPI_DOUBLE, p-1, 0, MPI_COMM_WORLD);
		if (x[I-1] <= a[0]) {
		    sorted = 1;
		} else {
		    int m=I-1, n=I-1;
		    for(int i=0; i<I; i++) {
			if(a[m] < x[n]) {
			    t[i] = x[n];
			    n--;
			} else {
			    t[i] = a[m];
			    m--;
			}
		    }
		    for(int i=0; i<I; i++) {
			a[i] = t[I-i-1];
		    }
		    sorted = 0;
		}
	    }
	}
	evenprocess = !evenprocess;
	rc = MPI_Barrier(MPI_COMM_WORLD);
	// printf("%d is %d\n", p, sorted);
	rc = MPI_Allreduce(&sorted, &global_sorted, 1, MPI_INT, MPI_LAND, MPI_COMM_WORLD);
	// printf("Process %d, Step: %d, Global: %d\n", p, step, global_sorted);
	if (global_sorted == 1) {
	    // printf("%d finished\n", p);
	    break;
	}
    }
    // printf("%d is writing to file\n", p);
    if (p == 0) {
	FILE* file = fopen("res.txt", "a");
	for(int i = 0; i < I; i++) {
	    fprintf(file, "%F\n", a[i]);
	}
	fclose(file); 
	tmp = 1;
	rc = MPI_Send(&tmp, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
    } else {
	rc = MPI_Recv(signal, 1, MPI_INT, p-1, 0, MPI_COMM_WORLD, status);
	if(*signal == p) {
	    FILE* file = fopen("res.txt", "a");
	    for(int i = 0; i < I; i++) {
		fprintf(file, "%.8F\n", a[i]);
	    }
	    fclose(file); 
	    if(p!=P-1) {
		tmp = p+1;
		rc = MPI_Send(&tmp, 1, MPI_INT, p+1, 0, MPI_COMM_WORLD);
	    }
	}
    }

    rc = MPI_Finalize();
    free(a);
    free(x);
    free(t);
    return 0;
}
