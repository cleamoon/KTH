/* 
 * This program demonstrates the use of MPI_Alltoall when
 * transpsong a square matrix.
 * For simplicity, the number of processes is 4 and the dimension
 * of the matrix is fixed to 128
 */

#include <stdio.h>
#include <mpi.h>

void
trans (double *a, int n)
/* transpose square matrix a, dimension nxn
 * Consider this as a black box for the MPI course
 */

{
    int i, j;
    int ij, ji, l;
    double tmp;
    ij = 0;
    l = -1;
    for (i = 0; i < n; i++)
	{
	    l += n + 1;
	    ji = l;
	    ij += i + 1;
	    for (j = i+1; j < n; j++)
		{
		    tmp = a[ij];
		    a[ij] = a[ji];
		    a[ji] = tmp;
		    ij++;
		    ji += n;
		}
	}
}

int
main (int argc, char *argv[])
{
    double a[128][32];
    double b[128][32];

    int i, j, nprocs, rank;

    MPI_Init (&argc, &argv);
    MPI_Comm_size (MPI_COMM_WORLD, &nprocs);
    MPI_Comm_rank (MPI_COMM_WORLD, &rank);

    if(rank == 0)
	{
	    printf("Transposing a 128x128 matrix, divided among 4 processors\n");
	}
    if (nprocs != 4)
	{
	    if (rank == 0)
		printf ("Error, number of processes must be 4\n");
	    MPI_Finalize ();
	    return 1;
	}

    for (i = 0; i < 128; i++)
	for (j = 0; j < 32; j++)
	    a[i][j] = 1000 * i + j + 32 * rank; /* give every element a unique value */

    /* do the MPI part of the transpose */

    /* Tricky here is the number of items to send and receive. 
     * Not 128x32 as one may guess, but the amount to send to one process
     * and the amount to receive from any process */

    MPI_Alltoall (&a[0][0],	/* address of data to send  */
		  32 * 32,	/* number of items to send to one process  */
		  MPI_DOUBLE,	/* type of data  */
		  &b[0][0],	/* address for receiving the data  */
		  /* NOTE: send data and receive data may NOT overlap */
		  32 * 32,	/* number of items to receive 
				   from any process  */
		  MPI_DOUBLE,	/* type of receive data  */
		  MPI_COMM_WORLD);

    /* MPI_Alltoall does not a transpose of the data received, we have to
     * do this ourself: */

    /* transpose 4 square matrices, order 32x32: */

    for (i = 0; i < 4; i++)
	trans (&b[i * 32][0], 32);

    /* now check the result */

    for (i = 0; i < 128; i++)
	for (j = 0; j < 32; j++)
	    {
		if (b[i][j] != 1000 * (j + 32 * rank) + i )
		    {
			printf ("process %d found b[%d][%d] = %f, but %f was expected\n",
				rank, i, j, b[i][j], (double) (1000 * (j + 32 * rank) + i));
			MPI_Abort (MPI_COMM_WORLD,1);
			return 1;
		    }
	    }
    if (rank == 0)
	printf ("Transpose seems ok\n");

    MPI_Finalize ();
    return 0;
}
