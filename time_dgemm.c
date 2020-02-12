#include "stdio.h"
#include "stdlib.h"
#include "sys/time.h"
#include "time.h"

extern void dgemm_(char*, char*, int*, int*,int*, double*, double*, int*, double*, int*, double*, double*, int*);
extern int openblas_get_num_threads();

int main(int argc, char* argv[])
{
  int i;
  int m = 1000;
  int n = 1000;
  int k = 1000;
  
  printf("openblas_get_num_threads =  %d \n",openblas_get_num_threads());

  int sizeofa = m * k;
  int sizeofb = k * n;
  int sizeofc = m * n;
  char ta = 'N';
  char tb = 'N';
  double alpha = 1.2;
  double beta = 0.001;

  struct timeval start,finish;
  double duration;

  double* A = (double*)malloc(sizeof(double) * sizeofa);
  double* B = (double*)malloc(sizeof(double) * sizeofb);
  double* C = (double*)malloc(sizeof(double) * sizeofc);

  srand((unsigned)time(NULL));

  for (i=0; i<sizeofa; i++)
    A[i] = i%3+1;//(rand()%100)/10.0;

  for (i=0; i<sizeofb; i++)
    B[i] = i%3+1;//(rand()%100)/10.0;

  for (i=0; i<sizeofc; i++)
    C[i] = i%3+1;//(rand()%100)/10.0;
  //#if 0
  printf("m=%d,n=%d,k=%d,alpha=%lf,beta=%lf,sizeofc=%d\n",m,n,k,alpha,beta,sizeofc);
  gettimeofday(&start, NULL);
  // printf("dgemm_start\n");
  dgemm_(&ta, &tb, &m, &n, &k, &alpha, A, &m, B, &k, &beta, C, &m);
  // printf("dgemm_end\n");
  gettimeofday(&finish, NULL);

  duration = ((double)(finish.tv_sec-start.tv_sec)*1000000 + (double)(finish.tv_usec-start.tv_usec)) / 1000000;
  double gflops = 2.0 * m *n*k;
  gflops = gflops/duration*1.0e-6;

  printf("%dx%dx%d\t%lf s\t%lf MFLOPS\n", m, n, k, duration, gflops);

  free(A);
  free(B);
  free(C);
  return 0;
}