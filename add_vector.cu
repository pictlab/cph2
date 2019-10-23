#include<stdlib.h>
#include<stdio.h>
#include<time.h>

void init_array(double *a, const int N);
void print_array(double *a,const int N);
__global__
void vecAdd(double*a,double*b,double*c,int n)
{
 //get thread id
 int id = blockIdx.x*blockDim.x + threadIdx.x;
 
 if(id<n)
   c[id]=a[id]+b[id];

}


int main()
{
 srand(time(NULL));
 int n = 100;
 
 double *a,*b,*c;
 double *d_a,*d_b,*d_c;

 const int size = n*sizeof(double);

 a = (double*)malloc(size);
 b = (double*)malloc(size);
 c = (double*)malloc(size);

 cudaMalloc(&d_a,size);
 cudaMalloc(&d_b,size);
 cudaMalloc(&d_c,size);

 init_array(a,n);
 init_array(b,n);

 print_array(a,n);
 print_array(b,n);

 cudaMemcpy(d_a,a,size,cudaMemcpyHostToDevice);
 cudaMemcpy(d_b,b,size,cudaMemcpyHostToDevice);

 int blockSize,gridSize;
 
 //no. of threads in each thread block
 blockSize = 1024;
 //no of blocks in grid
 gridSize = (int)ceil((float)n/blockSize);

 vecAdd<<<gridSize,blockSize>>>(d_a,d_b,d_c,n);
 
 cudaThreadSynchronize();

 cudaMemcpy(c,d_c,size,cudaMemcpyDeviceToHost);

 print_array(c,n);

 cudaFree(d_a);
 cudaFree(d_b);
 cudaFree(d_c);
 delete[] a;
 delete[] b;
 delete[] c;

 return 0;
}

void init_array(double*a,const int N)
{
  for(int i=0;i<N;i++)
     a[i] = rand()%N + 1;


}

void print_array(double*a,const int N)
{
  for(int i=0;i<N;i++)
    printf("%f ",a[i]);
printf("\n");
}
