#include <stdio.h>
#include <math.h>
#include <complex.h>
#include <stdlib.h>
#include <mpi.h>

void separate (double complex * input, int n) {
    double complex * b = (double complex *) malloc (n/2*sizeof(double complex));  // get temp heap storage
    for(int i=0; i<n/2; i++)    // copy all odd elements to heap storage
        b[i] = input[i*2 + 1];
    for(int i=0; i<n/2; i++)    // copy all even elements to lower-half of a[]
        input[i] = input[i*2];
    for(int i=0; i<n/2; i++)    // copy all odd (from heap) to upper-half of a[]
        input[i+n/2] = b[i];
    free(b);                 // delete heap storage
}

void local_fft(double complex * input, int n, int N) {
    if (n > 1) {
	separate(input, n);
	local_fft(input, n/2, N);
	local_fft(input + n/2, n/2, N);
	for(int i=0; i < n/2; i++) {
            double complex e = input[i], o = input[i + n/2];
            double complex w = cexp( -2.0*I*M_PI*i/N );
	    input[   i   ] = e + w * o;
	    input[i + n/2] = e - w * o;
	}
	
    }
}

int main(int argc, char* argv[]) {
    int N, n, size, rank, k, r, pivot;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Status* status; 
    
    N = 16;
    n = N / size;
    pivot = N / 2;
    
    k = (int) round(log2(N));
    r = (int) round(log2(size));
    double complex * source = (double complex *) malloc (sizeof(double complex) * n);
    double complex * destination = (double complex *) malloc (sizeof(double complex) * n);
    double * temp;

    if (rank == 0) {
	double complex * input = (double complex *) malloc (sizeof(double complex) * N);
	for(int i=0; i<N; i++) {
	    input[i] = sin(3*2.0*M_PI*i/N);
	    printf("%F, ", input[i]);
	}
	MPI_Scatter(input, n, MPI_C_DOUBLE_COMPLEX, source, n, MPI_DOUBLE_COMPLEX, 0, MPI_COMM_WORLD);
	printf("\nDone scattering\n");
    }
    MPI_Barrier(MPI_COMM_WORLD);

    for(int i=0; i<N; i++) {
	printf("rank %d: %F + %F i\n", rank, creal(source[i]), cimag(source[i]));
    }
    
    for (int i=0; i<r; i++) {
	double complex wk = cexp(I*-2.0*M_PI*(N-i)/N);
	int step = pivot / size;
	printf("rank: %d, step: %d\n", rank, step);
	if(rank % (step*2) < step) {
	    // MPI_Sendrecv(source, n, MPI_C_DOUBLE_COMPLEX, rank, 0,
	    // 		 destination, n, MPI_C_DOUBLE_COMPLEX, rank + step, 0,
	    // 		 MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	    MPI_Send(source, n, MPI_C_DOUBLE_COMPLEX, rank + step, 0, MPI_COMM_WORLD);
	    MPI_Recv(destination, n, MPI_C_DOUBLE_COMPLEX, rank + step, 0, MPI_COMM_WORLD, status);
	    for(int j=0; j<n; j++) {
		source[j] = source[j] + destination[j] * wk;
	    }
	} else {
	    // MPI_Sendrecv(source, n, MPI_C_DOUBLE_COMPLEX, rank, 0,
	    // 		 destination, n, MPI_C_DOUBLE_COMPLEX, rank - step, 0,
	    // 		 MPI_COMM_WORLD, MPI_STATUS_IGNORE);
	    MPI_Recv(destination, n, MPI_C_DOUBLE_COMPLEX, rank - step, 0, MPI_COMM_WORLD, status);	    
	    MPI_Send(source, n, MPI_C_DOUBLE_COMPLEX, rank - step, 0, MPI_COMM_WORLD);
	    for(int j=0; j<n; j++) {
		source[j] = source[j] + destination[j] * wk;
	    }
	}
	pivot /= 2;
    }

    //local_fft(source, n, N);

    if(rank == 3) {
	for(int i=0; i<n; i++) {
	    printf("%d: %F + %F i\n", i, creal(source[i]), cimag(source[i]));
	}
    }
	

    MPI_Finalize();
    return 0;
}
