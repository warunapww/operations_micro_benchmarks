/** size of A = 4
    size of B = 4
    gridDim = 2
    blockDim = 2
    k= 2
    x = 2
**/

#include "vecmultKernel.h"
__global__ void MultiplyVectors(const float* A, const float* B, float* C)
{
	int B_start_index = (blockIdx.x)*k;
	int A_start_index = (threadIdx.x)*k;
	int C_width = k*gridDim.x;


	int t;
	float c_0_0, c_0_1, c_1_0, c_1_1;
	float a_0, a_1;
	float b_0, b_1;


	a_0 = A[A_start_index+0];
	a_1 = A[A_start_index+1];


	b_0 = B[B_start_index+0];
	b_1 = B[B_start_index+1];


	c_0_0 = 0;
	c_0_1 = 0;
	c_1_0 = 0;
	c_1_1 = 0;


	for (t = 0; t < 2; t++) {
		c_0_0 += a_0*b_0;
		c_0_1 += a_0*b_1;
		c_1_0 += a_1*b_0;
		c_1_1 += a_1*b_1;


/*
		a_0 += 10;
		a_1 += 10;


		b_0 += 10;
		b_1 += 10;


*/
	}


	C[(A_start_index+0)*C_width + B_start_index+0] = c_0_0;
	C[(A_start_index+0)*C_width + B_start_index+1] = c_0_1;
	C[(A_start_index+1)*C_width + B_start_index+0] = c_1_0;
	C[(A_start_index+1)*C_width + B_start_index+1] = c_1_1;


}
