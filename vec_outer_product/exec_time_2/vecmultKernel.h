#ifndef _VECMULTKERNEL_H_
#define _VECMULTKERNEL_H_
// Defines
#define GridWidth 13
#define BlockWidth 384
#define ValuesPerThread 11
#define k 3

__global__ void MultiplyVectors(const float* A, const float* B, float* C);

#endif //_VECMULTKERNEL_H_
