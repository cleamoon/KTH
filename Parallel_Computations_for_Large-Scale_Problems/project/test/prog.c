#include <stdio.h>
#include <math.h>
#include <complex.h>
#include <stdlib.h>
#include <mpi.h>


unsigned int reverse(unsigned int x, int r, int m) {
    unsigned int y = 0;

    x = x >> (r-m-1);

    for(int i = 0; i < m+1; i++) {
	y |= x & 1;
	x = x >> 1;
	if(i < m) y = y << 1;
    }
    
    y = y << (r-m-1);
    
    return y;
}


int main(int argc, char ** argv) {
    int N, n, rank, size, k, s, e;
    double complex * input, * local, * result;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    FILE * fp;
    fp = fopen(argv[1], "r");
    fscanf(fp, "%d", &N);
    
    input = (double complex *) malloc (sizeof(double complex)*N);
    result = (double complex *) malloc (sizeof(double complex)*N);
    local = (double complex *) malloc (sizeof(double complex)*(N/size));
    k = (int) round(log2(N));
    n = N/size;
    s = rank*n;
    e = s + n;
    
    for(int i = 0; i < N; i++)
	fscanf(fp, "%lf", input+i);
    fclose(fp);
    
    double complex * R = malloc(sizeof(double complex)*n);
    double complex * S = malloc(sizeof(double complex)*n);
    double complex * Sk = malloc(sizeof(double complex)*n);
    double complex * temp2;

    for(int i = 0; i < n; i++)
	R[i] = input[i+s];

    for(int m = 0; m < k; m++) {
	for(int i = 0; i < n; i++) {
	    Sk[i] = S[i] = R[i];
	}
	unsigned int bit = 1 << (k - m - 1);
	unsigned int notbit = ~bit;

	int dest, src;
	int splitPoint = size / (1 << (m+1));

	if(splitPoint > 0) {
	    if( ( rank % (splitPoint*2) ) < splitPoint) {
		src = rank + splitPoint;
		dest = rank + splitPoint;
		printf("dest: %d, src: %d\n", src, src);
		MPI_Sendrecv(S, n, MPI_C_DOUBLE_COMPLEX, dest, 0,
			     Sk, n, MPI_C_DOUBLE_COMPLEX,  src, 0,
			     MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	    }
	    else {
		src = rank - splitPoint;
		dest = rank - splitPoint;
		printf("dest: %d, src: %d\n", dest, src);
		MPI_Sendrecv(Sk, n, MPI_C_DOUBLE_COMPLEX, src, 0,
			     S, n, MPI_C_DOUBLE_COMPLEX,  dest, 0,
			     MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	    }

	}
	else {
	    for(int i = 0; i < n; i++)
		Sk[i] = S[i];
	}

	for(int i = s, l = 0; l < n; i++, l++) {
	    int j = (i & notbit) % n;
	    int k = (i | bit) % n;

	    int expFactor = reverse(i, k, m);
	    R[l] = S[j] + Sk[k] * cexp( (2*M_PI*I*expFactor)/N );
	}
    }

    printf("here is done\n");
    
    for(int i = 0; i < n; i++) {
	local[i] = R[i];
    }

    free((void *) R);
    free((void *) S);
    free((void *) Sk);
    
    

    MPI_Gather(local, N/size, MPI_C_DOUBLE_COMPLEX, result, N/size, 
               MPI_C_DOUBLE_COMPLEX, 0, MPI_COMM_WORLD);

    if(rank == 0) {
	for(int i = 0; i < N; i++) {
	    if(cabs(result[i]) > 32) {
		printf("local[%d] = %lf + %lf*i\n", i, creal(result[i]), cimag(result[i]) );
	    }
	}
    }

    free(input);
    free(local);
    free(result);

    MPI_Finalize();

    return 0;
}

