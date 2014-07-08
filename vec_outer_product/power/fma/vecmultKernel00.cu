/** x = 3
**/    #include "vecmultKernel.h"
__global__ void MultiplyVectors(const float* A, const float* B, float* C)
{
	int B_start_index = blockIdx.x*ValuesPerThread;
	int A_start_index = threadIdx.x*ValuesPerThread;
	int C_width = gridDim.x*ValuesPerThread;


	int t;
	float c_0_0, c_0_1, c_0_2, c_1_0, c_1_1, c_1_2, c_2_0, c_2_1, c_2_2;
	float a_0, a_1, a_2;
	float b_0, b_1, b_2;


	a_0 = A[A_start_index+0];
	a_1 = A[A_start_index+1];
	a_2 = A[A_start_index+2];


	b_0 = B[B_start_index+0];
	b_1 = B[B_start_index+1];
	b_2 = B[B_start_index+2];


	c_0_0 = 0;
	c_0_1 = 0;
	c_0_2 = 0;
	c_1_0 = 0;
	c_1_1 = 0;
	c_1_2 = 0;
	c_2_0 = 0;
	c_2_1 = 0;
	c_2_2 = 0;


	for (t = 0; t < k; t++) {
		c_0_0 += a_0*b_0;
		c_0_1 += a_0*b_1;
		c_0_2 += a_0*b_2;
		c_1_0 += a_1*b_0;
		c_1_1 += a_1*b_1;
		c_1_2 += a_1*b_2;
		c_2_0 += a_2*b_0;
		c_2_1 += a_2*b_1;
		c_2_2 += a_2*b_2;


		a_0 = a_0*1.1f+1.7f;
		a_1 = a_1*1.1f+1.7f;
		a_2 = a_2*1.1f+1.7f;


		b_0 = b_0*1.1f+1.7f;
		b_1 = b_1*1.1f+1.7f;
		b_2 = b_2*1.1f+1.7f;


	}


	C[(A_start_index+0)*C_width + B_start_index+0] = c_0_0;
	C[(A_start_index+0)*C_width + B_start_index+1] = c_0_1;
	C[(A_start_index+0)*C_width + B_start_index+2] = c_0_2;
	C[(A_start_index+1)*C_width + B_start_index+0] = c_1_0;
	C[(A_start_index+1)*C_width + B_start_index+1] = c_1_1;
	C[(A_start_index+1)*C_width + B_start_index+2] = c_1_2;
	C[(A_start_index+2)*C_width + B_start_index+0] = c_2_0;
	C[(A_start_index+2)*C_width + B_start_index+1] = c_2_1;
	C[(A_start_index+2)*C_width + B_start_index+2] = c_2_2;


}
