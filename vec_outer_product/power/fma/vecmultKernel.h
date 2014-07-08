#ifndef _VECMULTKERNEL_H_
#define _VECMULTKERNEL_H_
// Defines
#define GridWidth 26
#define BlockWidth 896
#define ValuesPerThread 3
#define k 100000

__global__ void MultiplyVectors(const float* A, const float* B, float* C);

#endif //_VECMULTKERNEL_H_
