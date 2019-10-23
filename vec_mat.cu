#include<stdlib.h>
#include<stdio.h>
#include<time.h>

void init_array(float*a ,const int N);
void init_mat(float*a ,const int N,const int M);
void print_array(float*a ,const int N);
void print_mat(float*a ,const int N,const int M);


__global__
void kernel(float* vec,float* mat,float* out,const int N,const int M)
{
  int tid = threadIdx.x + blockIdx.x*blockDim.x;
  float sum=0;
  if(tid<M)
  {
    if(tid<M)
       {
          for(int i=0;i<N;i++)
             sum = sum + vec[i]*mat[(i*M)+ tid];
          out[tid]=sum;
       }

  }


}

int main()
{
srand(time(NULL));
 
float *a,*b,*c;
float *d_a,*d_b,*d_c;

int N=3;
int M=4;
//a = [1*3],b= [3*4], c=[1*4]

a = (float*)malloc(sizeof(float)*N);
b = (float*)malloc(sizeof(float)*N*M);
c = (float*)malloc(sizeof(float)*M);

init_array(a,N);
init_mat(b,N,M);
init_array(c,M);

printf("Initial data:\n");
print_array(a,N);

printf("\n\n\n\n");
print_mat(b,N,M);
printf("\n\n\n\n");

print_array(c,M);

printf("\n\n\n\n");

cudaMalloc(&d_a,sizeof(float)*N);
cudaMalloc(&d_b,sizeof(float)*N*M);
cudaMalloc(&d_c,sizeof(float)*M);

cudaMemcpy(d_a,a,sizeof(float)*N,cudaMemcpyHostToDevice);
cudaMemcpy(d_b,b,sizeof(float)*N*M,cudaMemcpyHostToDevice);

kernel<<<M/256+1,256>>>(d_a,d_b,d_c,N,M);

cudaError_t err = cudaGetLastError();
if (err != cudaSuccess) 
    printf("Error: %s\n", cudaGetErrorString(err));

cudaMemcpy(c,d_c,sizeof(float)*M,cudaMemcpyDeviceToHost);

printf("Final data:\n");
print_array(c,M);

cudaFree(d_a);
cudaFree(d_b);
cudaFree(d_c);

delete[] a;
delete[] b;
delete[] c;

return 0;
}

void init_array(float* a,const int N)
{
  for(int i=0;i<N;i++)
    a[i]=rand()%N+1;
}

void init_mat(float*a ,const int N,const int M)
{
   for(int i=0;i<N;i++)
     for(int j=0;j<M;j++)
        a[i*M + j]= rand()%N +1;
}

void print_array(float* a,const int N)
{
  for(int i=0;i<N;i++)
     printf("%f  ",a[i]);
printf("\n");
}

void print_mat(float*a ,const int N,const int M)
{
   for(int i=0;i<N;i++)
   {
     for(int j=0;j<M;j++)
           {
             printf("%  f",a[i*M + j]);
             }
     printf("\n");
}
printf("\n");
}

