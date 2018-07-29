#include <stdio.h>
#include <string.h>
#include <complex.h>
#include <mpi.h>

double cabs(double complex z) {
  return sqrt(creal(z)*creal(z) + cimag(z)*cimag(z));
}

int cal_pixel (double complex d, int b, int N) {
  int count = 1;
  double complex z = 0;
  while (( cabs(z) < b ) && ( count < N )) {
    z = z*z + d;
    count ++;
  }
  return count;
}

int main(int argc, char ** argv) {
  int N=256, b=2, w=2048, h=2048;
  int size, rank, length;
  int ierr;

  ierr = MPI_Init (&argc, &argv);
  ierr = MPI_Comm_size(MPI_COMM_WORLD, &size);
  ierr = MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Status *status;
  length = w*h/size;
  unsigned char color[w*h];
  unsigned char message[length];

  if (rank == 0) {
    FILE * fp;
    fp = fopen("color.txt", "w");
    for (int i=1; i < size; i++) {
        ierr = MPI_Recv(message, length, MPI_UNSIGNED_CHAR, i, i, MPI_COMM_WORLD, status);
        for(int j=0; j < length; j++) {
          fprintf(fp, "%hhu ", message[j]);
        }
	fprintf(fp, "\n");
    }
    fclose(fp);
  } else {
    //for(int i=0; i<length; i++) {
      double dx = 2*b/(w-1), dy = 2*b/(h-1);
      int wp = w/size, hp = h;
      double xoff = rank*wp, yoff = 0;
      int count=0;
      for (int x = 0; x < wp ; x ++ ) {
        double dreal = (x + xoff)*dx-b;
        for (int y = 0; y < hp; y ++ ) {
          double dimag = (y + yoff)*dy-b;
          double complex d = dreal+dimag * I;
          message[count] = cal_pixel(d, b, N);
          count++;
        }
      //}
      ierr = MPI_Send(message, length, MPI_UNSIGNED_CHAR, 0, rank, MPI_COMM_WORLD);
    }
  }
  return 0;
}
