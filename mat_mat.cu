#include<stdlib.h>
#include<stdio.h>
#include<time.h>

#define BLOCK_SIZE 16
void init_mat(float*a ,const int N,const int M);
void print_mat(float*a ,const int N,const int M);

__global__
void matrixMultiply(float*a,float*b,float*c,int m,int n,int k)
{
 int row = blockIdx.y*blockDim.y + threadIdx.y;
  int col = blockIdx.x*blockDim.x + threadIdx.x;
 int  sum=0;

 if(col<k && row<m)
 {
    for(int i=0;i<n;i++)
     {
        sum += a[row*n+i]*b[i*k+col];
     }
    c[row*k + col]=sum;

 }


}

int main()
{
srand(time(NULL));

float *a,*b,*c;
float *d_a,*d_b,*d_c;

int M=5;
int N=4;
int P =3;
//a = [5*4],b= [4*3], c=[5*3]

a = (float*)malloc(sizeof(float)*M*N);
b = (float*)malloc(sizeof(float)*N*P);
c = (float*)malloc(sizeof(float)*M*P);


init_mat(a,M,N);
init_mat(b,N,P);
//init_mat(c,M,P);


printf("Initial data:\n");
print_mat(a,M,N);
print_mat(b,N,P);
print_mat(c,M,P);

cudaMalloc(&d_a,sizeof(float)*M*N);
cudaMalloc(&d_b,sizeof(float)*N*P);
cudaMalloc(&d_c,sizeof(float)*M*P);

cudaMemcpy(d_a,a,sizeof(float)*M*N,cudaMemcpyHostToDevice);
cudaMemcpy(d_b,b,sizeof(float)*N*P,cudaMemcpyHostToDevice);

//dim3 dimGrid((P + BLOCK_SIZE - 1) / BLOCK_SIZE, (M + BLOCK_SIZE - 1) / BLOCK_SIZE);
dim3 dimGrid(1,1);
dim3 dimBlock(16, 16);
matrixMultiply<<<dimGrid,dimBlock>>>(d_a,d_b,d_c,M,N,P);
cudaMemcpy(c,d_c,sizeof(float)*M*P,cudaMemcpyDeviceToHost);

printf("Final data:\n");
print_mat(c,M,P);

cudaFree(d_a);
cudaFree(d_b);
cudaFree(d_c);

delete[] a;
delete[] b;
delete[] c;

return 0;
}

void init_mat(float*a ,const int N,const int M)
{
   for(int i=0;i<N;i++)
     for(int j=0;j<M;j++)
        a[i*M + j]= rand()%N +1;
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
