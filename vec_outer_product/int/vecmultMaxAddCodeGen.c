#include <stdio.h>

int main(int argc, char** argv) {
	int i,j,k;
	int x = atoi(argv[1]);
	int iterations = atoi(argv[2]);
	int gridDim = atoi(argv[3]);
	int blockDim = atoi(argv[4]);

	int vectorSize = x * gridDim * blockDim;
	
	int blockSize = x * blockDim;
	
	int size_A = blockDim * x;
	int size_B = gridDim * x;

	printf("/** size of A = %d\n    size of B = %d\n    gridDim = %d\n    blockDim = %d\n    k= %d\n    x = %d\n**/\n\n", size_A, size_B, gridDim, blockDim, iterations, x);
	printf("__global__ void MultiplyVectors(const int* A, const int* B, int* C, int x, int k)\n{\n");
	printf("\tint B_start_index = (blockIdx.x*gridDim.y + blockIdx.y)*x;\n");
	printf("\tint A_start_index = (threadIdx.x*blockDim.y + threadIdx.y)*x;\n");
	printf("\tint C_width = x*gridDim.x*gridDim.y;\n");
    //int endIndex = blockStartIndex + blockSize;
	printf("\n\n");
	
	printf("\tint t;\n");

	printf("\tint ");
	for (i = 0; i < x; i++) {
		for (j = 0; j < x; j++) {
			if (i == x - 1 && j == x - 1) {
				printf("c_%d_%d;\n",i,j);
			} else {
				printf("c_%d_%d, ",i,j);
			}
		}
	}

	printf("\tint ");
    for (i = 0; i < x; i++) {
		if (i == x - 1) {
			printf("a_%d;\n",i);
		} else {
			printf("a_%d, ",i);
		}
    }

	printf("\tint ");
    for (i = 0; i < x; i++) {
		if (i == x - 1) {
			printf("b_%d;\n",i);
		} else {
			printf("b_%d, ",i);
		}
    }
	printf("\n\n");

    for (i = 0; i < x; i++) {
		printf("\ta_%d = A[A_start_index+%d];\n",i,i);
    }
	printf("\n\n");

    for (i = 0; i < x; i++) {
		printf("\tb_%d = B[B_start_index+%d];\n",i,i);
    }
	printf("\n\n");

    for (i = 0; i < x; i++) {
    	for (j = 0; j < x; j++) {
			printf("\tc_%d_%d = 0;\n",i,j);
		}
    }
	printf("\n\n");

	//printf("#pragma unroll\n");
	printf("\tfor (t = 0; t < %d; t++) {\n", iterations);	
	//printf("\tfor (t = 0; t < k; t++) {\n");	
	//for (k = 0; k < iterations; k++) {
		for (i = 0; i < x; i++) {
			for (j = 0; j < x; j++) {
				//printf("\t\tc_%d_%d += a_%d*b_%d;\n",i,j,i,j);
				printf("\t\tc_%d_%d = max(c_%d_%d, (a_%d+b_%d));\n",i,j,i,j,i,j);
			}
		}
	printf("\n\n");
//  printf("/*\n");
	for (i = 0; i < x; i++) {
        printf("\t\ta_%d += 10;\n",i);
    }
    printf("\n\n");

    for (i = 0; i < x; i++) {
        printf("\t\tb_%d += 10;\n",i);
    }
    printf("\n\n");
  //  printf("*/\n");


	//}
	printf("\t}\n");

	printf("\n\n");
	
	for (i = 0; i < x; i++) {
		for (j = 0; j < x; j++) {
			printf("\tC[(A_start_index+%d)*C_width + B_start_index+%d] = c_%d_%d;\n", i,j,i,j);
		}
	}
	printf("\n\n");
	printf("}\n");
	
	return 1;
}
