#ifndef _VECMULTKERNEL_H_
#define _VECMULTKERNEL_H_
// Defines
//#define GridWidth __GridWidth__
//#define BlockWidth __BlockWidth__
#define ValuesPerThread 10
//#define k __k__

__global__ void MultiplyVectors(const float* A, const float* B, float* C, int repetitions);

#endif //_VECMULTKERNEL_H_
