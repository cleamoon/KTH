/* PROGRAM FOR ONE_DIMENSIONAL STEADY-STATE HEAT EQUATION */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/* Solve a tridiagonal system
     L[i]*x[i-1] + D[i]*x[i] R[i]*x[i+1] = y[i], i = 0..n-1
     Inputs are the number of equations, n, the vectors
     L, D, R and the right hand side y. The solution is returned in y.
     L[0] and R[n-1] are ssumed to be zero.
*/

void trisolve(int n, double *L, double *D, double *R, double *y) {
  int i;
  double g;

  /* Gaussian elimination */
  for (i = 0; i<n-1; i++) {
    g = L[i+1] / D[i];
    D[i+1] = D[i+1] - g*R[i];
    y[i+1] = y[i+1] - g*y[i];
  }

  /* Back substitution */
  y[n-1] = y[n-1] / D[n-1];
  for(i = n-2; i>=0; i--) {
    y[i] = (y[i] - R[i]*y[i+1]) / D[i];
  }
}

int main(void) {
  double x0, x1, t0, t1, h, h2inv;
  double *x, *y, *L, *D, *R;
  int i, n;
  char filename[80];
  FILE *outfile;

  printf("*** Program for one-dimensional steady state head-equation ***\n");
  printf("Give x0 and x1: ");
  scanf("%lf%lf", &x0, &x1);
  printf("Give temperatures at x0 and x1: ");
  scanf("%lf%lf", &t0, &t1);
  printf("Give number of discretization points: ");
  scanf("%d", &n);

  x = malloc(sizeof(double) * n);
  y = malloc(sizeof(double) * n);
  L = malloc(sizeof(double) * n);
  D = malloc(sizeof(double) * n);
  R = malloc(sizeof(double) * n);

  h = (x1-x0)/(n-1);
  h2inv = 1.0/(h*h);

  /* Set up equation system:
     (y[i-1] - 2y[i] + y[i+1])/h^2 = 0
     y[0] = t0, y[1] = t1
  */
  x[0] = x0; y[0] = t0;
  D[0] = 1.0; L[0] = 0.0; R[0] = 0.0;
  for (i = 1; i<n-1; i++) {
    x[i] = x0 + ((double) i)/(n-1) * (x1-x0);
    y[i] = 0.0;
    L[i] = h2inv;
    D[i] = -2.0*h2inv;
    R[i] = h2inv;
  }
  x[n-1] = x1; y[n-1] = t1;
  D[n-1] = 1.0; L[n-1] = 0.0; R[n-1] = 0.0;

  /* Solve system */
  trisolve (n, L, D, R, y);

  /* Ask user for a filename, and store solution to file. */
  printf("Solution computed.\nName of output file:");
  scanf("%s", filename);
  outfile = fopen(filename, "w");
  if (outfile != NULL) {
    for (i = 0; i<n; i++) {
      fprintf(outfile, "%10.5f %10.5f\n", x[i], y[i]);
    }
    fclose(outfile);
  } else {
    printf ("Unable to open output file %s. Solution not saved.\n", filename);
  }

  free(x); free(y); free(L); free(D); free(R);
  printf("*** Finished ***\n");
  return 0;
}
    
