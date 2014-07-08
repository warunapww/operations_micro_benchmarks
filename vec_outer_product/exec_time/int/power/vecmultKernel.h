///
/// vecAddKernel.h
/// For CSU CS575 Spring 2011
/// Instructor: Wim Bohm
/// Based on code from the CUDA Programming Guide
/// By David Newman
/// Created: 2011-02-16
/// Last Modified: 2011-02-16 DVN
///
/// Kernels written for use with this header
/// add two Vectors A and B in C on GPU
/// 


__global__ void MultiplyVectors(const int* A, const int* B, int* C, int x, int k);

