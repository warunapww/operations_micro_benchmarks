#ifndef _VECMULTKERNEL_H_
#define _VECMULTKERNEL_H_
// Defines
//#define GridWidth 2
//#define BlockWidth 2
#define ValuesPerThread 2
#define k 100

__global__ void MultiplyVectors(const float* A, const float* B, float* C);

#endif //_VECMULTKERNEL_H_
