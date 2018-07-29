/* 
   Result can be plotted with the following matlab command: 
   * load('color.txt')
   * image(color'*12)
*/

#include <stdio.h>
#include <string.h>
#include <complex.h>
#include <math.h>
#include <mpi.h>

double cabs(double complex z) {  
  return sqrt(creal(z) * creal(z) + cimag(z) * cimag(z));
}

int cal_pixel(double complex d, double b, int N) {
  int count = 0;
  double complex z = 0;
  while ((cabs(z) < b) && (count < N)) {
    z = z * z + d;
    count++;
  }
  // printf("%d\n", count);
  return count;
}

int main(int argc, char **argv) {
  int N = 256, w = 2048, h = 2048;
  double b = 2;
  int ierr, size, rank;
  ierr = MPI_Init(&argc, &argv);
  ierr = MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  ierr = MPI_Comm_size(MPI_COMM_WORLD, &size);
  //printf("Hello world! I'm process %i out of %i processes\n", rank, size);
  int length = w / size * h;
  unsigned char color[length];
  if (rank == 0) {
    FILE * fp;
    fp = fopen("color.txt", "w");
    double dx = 2*b/(w - 1), dy = 2*b/(h - 1);
    int wp = w / size, hp = h;
    for (int x = 0; x < wp; x++) {
      double dreal = (x) * dx - b;
      for (int y = 0; y < hp; y++) {
	double dimag = (y) * dy - b;
	double complex d = dreal + dimag * I;
	color[x * h + y] = cal_pixel(d, b, N);
      }
    }
    for (int j = 0; j < length; j++) {
      fprintf(fp, "%hhu ", color[j]);
      if (!((j + 1) % h))
	fprintf(fp, "\n");
    }
    for (int i = 1; i < size; i++) {
      //      if(i != 0) {
      MPI_Status *status;
      ierr = MPI_Recv(color, length, MPI_UNSIGNED_CHAR, i, i, MPI_COMM_WORLD, status);
      //	printf("i: %d\n", i);
      //      }
      for (int j = 0; j < length; j++) {
	fprintf(fp, "%hhu ", color[j]);
	if (!((j + 1) % h))
	  fprintf(fp, "\n");
      }
    }
    fclose(fp);
  } else {
    double dx = 2*b/(w - 1), dy = 2*b/(h - 1);
    int wp = w / size, hp = h;
    double xoff = rank * wp, yoff = 0;
    for (int x = 0; x < wp; x++) {
      double dreal = (x + xoff) * dx - b;
      for (int y = 0; y < hp; y++) {
	double dimag = (y + yoff) * dy - b;
	double complex d = dreal + dimag * I;
	color[x * h + y] = cal_pixel(d, b, N);
      }
    }
    ierr = MPI_Send(color, length, MPI_UNSIGNED_CHAR, 0, rank, MPI_COMM_WORLD);
  }
  ierr = MPI_Finalize();
  return 0;
}


