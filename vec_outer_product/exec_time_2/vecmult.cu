// Includes
#include <stdio.h>
#include "vecmultKernel.h"

#include "high_resolution_power.h"

/**
 * This macro checks return value of the CUDA runtime call and exits
 * the application if the call failed.
 */
#define CUDA_CHECK_RETURN(value) {                    \
    cudaError_t _m_cudaStat = value;                    \
    if (_m_cudaStat != cudaSuccess) {                   \
      fprintf(stderr, "Error: %s at line %d in file %s\n",        \
          cudaGetErrorString(_m_cudaStat), __LINE__, __FILE__);   \
          exit(1);        \
    } }



// Variables for host and device vectors.
float* h_A; 
float* h_B; 
float* h_C; 
float* d_A; 
float* d_B; 
float* d_C; 

float* h_C_cpu; 
//int GridWidth;
//int BlockWidth;
//int repetitions;
// Utility Functions
void Cleanup(bool);
void checkCUDAError(const char *msg);

void cuda_function_call() {
  dim3 dimGrid(GridWidth);                    
  dim3 dimBlock(BlockWidth);                 
  MultiplyVectors<<<dimGrid, dimBlock>>>(d_A, d_B, d_C);
  CUDA_CHECK_RETURN(cudaGetLastError()); 
}

// Host code performs setup and calls the kernel.
int main(int argc, char** argv)
{
  int N; //Vector size

  int i, j, t;
	// Parse arguments.
    if(argc != 1){
     printf("Usage: %s GridWidth BlockWidth\n", argv[0]);
     printf("GridWidth - number of thread blocks.\n");
     printf("BlockWidth - number of threads per thread block\n");
    // printf("Repetitions - number of repetitions of the computations\n");
     exit(0);
    } else {
//      sscanf(argv[1], "%d", &ValuesPerThread);
//      sscanf(argv[2], "%d", &k);
  //    sscanf(argv[1], "%d", &GridWidth);
//      sscanf(argv[2], "%d", &BlockWidth);
 //     sscanf(argv[3], "%d", &repetitions);
    }      
  //int k = repetitions;
	int size_A = BlockWidth * ValuesPerThread;
	int size_B = GridWidth * ValuesPerThread;

	printf("Size of A: %d, Size of B: %d\n", size_A, size_B);

    // Determine the number of threads .
    // N is the total number of values to be in a vector
//    N = ValuesPerThread * GridWidth * BlockWidth;
//    printf("Total vector size: %d : Iterations: %d\n", N, k); 
    // size_t is the total number of bytes for a vector.
//    size_t size = N * sizeof(float);

    // Tell CUDA how big to make the grid and thread blocks.
    // Since this is a vector addition problem,
    // grid and thread block are both one-dimensional.
    dim3 dimGrid(GridWidth);                    
    dim3 dimBlock(BlockWidth);                 

    // Allocate input vectors h_A and h_B in host memory
    h_A = (float*)malloc(size_A*sizeof(float));
    if (h_A == 0) Cleanup(false);
    h_B = (float*)malloc(size_B*sizeof(float));
    if (h_B == 0) Cleanup(false);
    h_C = (float*)malloc(size_A*size_B*sizeof(float));
    if (h_C == 0) Cleanup(false);
    
    h_C_cpu = (float*)malloc(size_A*size_B*sizeof(float));
    if (h_C_cpu == 0) Cleanup(false);
	
//	printf("1 \n");

    // Allocate vectors in device memory.
    CUDA_CHECK_RETURN(cudaMalloc((void**)&d_A, size_A*sizeof(float)));
	//printf("1.1\n");
    CUDA_CHECK_RETURN(cudaMalloc((void**)&d_B, size_B*sizeof(float)));
//	printf("1.2\n");
    CUDA_CHECK_RETURN(cudaMalloc((void**)&d_C, size_A*size_B*sizeof(float)));

//	printf("2\n");
    // Initialize host vectors h_A and h_B
    for(i=0; i <size_A; ++i){
     h_A[i] = (float)i;
    }
    for(i=0; i <size_B; ++i){
     h_B[i] = (float)(size_B-i);   
    }

    // Copy host vectors h_A and h_B to device vectores d_A and d_B
    CUDA_CHECK_RETURN(cudaMemcpy(d_A, h_A, size_A*sizeof(float), cudaMemcpyHostToDevice));
    CUDA_CHECK_RETURN(cudaMemcpy(d_B, h_B, size_B*sizeof(float), cudaMemcpyHostToDevice));


//	printf("4\n");
    
//	printf("5\n");
	// Compute elapsed time 
    long long exec_time = 0;
    exec_time = get_exec_time_in_nanoseconds(cuda_function_call);
    double time = exec_time/1e9; //s

	// Compute floating point operations per second.
    //double nFlops = size_A*size_B*k*2 + 2*k*ValuesPerThread*GridWidth*BlockWidth;
    //double nFlops = (double)size_A*(double)size_B*(double)k*(double)2 + (double)2*(double)k*(double)ValuesPerThread*(double)GridWidth*(double)BlockWidth;
    double nFlops = (double)size_A*(double)size_B*(double)k*(double)2 + (double)2*(double)k*(double)ValuesPerThread*(double)GridWidth*(double)BlockWidth*(double)2;
    //float nFlopsPerSec = 1e3*nFlops/time;
    //float nGFlopsPerSec = nFlopsPerSec*1e-9;

    double nGFlopsPerSec = nFlops/exec_time;

	//printf("%f :: %f", (double)size_A*(double)size_B*(double)k*(double)2, (double)2*(double)k*(double)ValuesPerThread*(double)GridWidth*(double)BlockWidth);
	// Compute transfer rates.
    double nBytes = size_A*sizeof(float) + size_B*sizeof(float) + size_A*size_B*sizeof(float); // 2N words in, N*N word out
    //float nBytesPerSec = 1e3*nBytes/time;
    //float nGBytesPerSec = nBytesPerSec*1e-9;
    double nGBytesPerSec = nBytes/exec_time;

	// Report timing data.
    printf( "%d %d %d %d Time: %f (ms), GFLOPS: %f GBytesS: %f\n", 
             GridWidth, BlockWidth, k, ValuesPerThread, time*1e3, nGFlopsPerSec, nGBytesPerSec);
     
    // Copy result from device memory to host memory
    CUDA_CHECK_RETURN(cudaMemcpy(h_C, d_C, size_A*size_B*sizeof(float), cudaMemcpyDeviceToHost));

    // Verify & report result
    memset(h_C_cpu, 0, size_A*size_B*sizeof(float));

    for (t = 0; t < k; t++) {
      if (t > 0) {
        for (i = 0; i < size_A; i++) {
          h_A[i] = h_A[i]*1.1f + 1.7f;
        }
        for (j = 0; j < size_B; j++) {
          h_B[j] = h_B[j]*1.1f + 1.7f;
        }
      }
      for (i = 0; i < size_A; i++) {
        for (j = 0; j < size_B; j++) {
          h_C_cpu[i*size_B + j] += h_A[i]*h_B[j];
        }
      }
      
    }


    printf("Result [%d,%d] expected %f*%f=%.5f, got %.5f, error: %e\n", 0,0, h_A[0], h_B[0], h_C_cpu[0], h_C[0], h_C[0] - h_C_cpu[0]);
/*
    for(i=0; i <size_A; ++i){
     printf("%.1f ", h_A[i]);
    }
     printf("\n");
    for(i=0; i <size_B; ++i){
     printf("%.1f ", h_B[i]);
    }
     printf("\n");

    for (i = 0; i < size_A; ++i) {
    	for (j = 0; j < size_B; ++j) {
        printf("%.1f,%.1f ", h_C[i*size_B+j], h_C_cpu[i*size_B+j]);
      }
      printf(":");
    }
*/
    for (i = 0; i < size_A; ++i) {
    	for (j = 0; j < size_B; ++j) {
			float val = h_C[i*size_B+j];
			if (fabs(val - h_C_cpu[i*size_B+j] ) > 1e0) {
				printf("Result error: i=%d, j=%d, expected %.5f, got %.5f, error: %e\n", i, j, h_C_cpu[i*size_B+j], val, val - h_C_cpu[i*size_B+j]);
				break;
			}
		}
		if (j != size_B) {
			break;
		}
    }
    printf("\nTest %s \n", (i == size_A && j == size_B) ? "PASSED" : "FAILED");

	// Clean up and exit.
    Cleanup(true);
}

void Cleanup(bool noError) {  // simplified version from CUDA SDK
    // Free device vectors
    if (d_A)
        CUDA_CHECK_RETURN(cudaFree(d_A));
    if (d_B)
        CUDA_CHECK_RETURN(cudaFree(d_B));
    if (d_C)
        CUDA_CHECK_RETURN(cudaFree(d_C));

    // Free host memory
    if (h_A)
        free(h_A);
    if (h_B)
        free(h_B);
    if (h_C)
        free(h_C);
        
    
    fflush( stdout);
    fflush( stderr);

    exit(0);
}


