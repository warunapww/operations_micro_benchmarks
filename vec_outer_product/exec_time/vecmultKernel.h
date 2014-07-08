#ifndef _VECMULTKERNEL_H_
#define _VECMULTKERNEL_H_
// Defines
//#define GridWidth __GridWidth__
//#define BlockWidth __BlockWidth__
#define ValuesPerThread 11
#define k 434876

__global__ void MultiplyVectors(const float* A, const float* B, float* C);

#endif //_VECMULTKERNEL_H_
