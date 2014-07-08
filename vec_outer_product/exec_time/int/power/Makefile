CC := nvcc
CUDA_CC :=  $(COMPUTE_CAPABILITY)
OPTIONS := -O3 -Xptxas -v -arch=${CUDA_CC}
LIB := -L/s/chopin/e/proj/AlphaZ/waruna/lib -L/s/chopin/e/proj/AlphaZ/waruna/papi/installation/5.3.0/lib -lnvidia-ml -lpapi -lcublas

OBJECTS := vecmultKernel00.o high_resolution_power.o

EXECS :=  vecmult00 
all:$(EXECS)

vecmultCodeGen : vecmultCodeGen.c
	gcc -o $@ $<

vecmultMaxAddCodeGen : vecmultMaxAddCodeGen.c
	gcc -o $@ $<
#######################################################################
vecmultKernel00.o : vecmultKernel00.cu
	nvcc $< -c -o $@ $(OPTIONS)
#	nvcc $< -c -o $@ $(OPTIONS) -arch=sm_13
#	nvcc $< -c -o $@ $(OPTIONS) -ext=all -dir=a.out.devcode

vecmult00 : vecmult.cu vecmultKernel.h vecmultKernel00.o high_resolution_power.o
	nvcc $< ${OBJECTS} -o $@ $(LIB) $(INCLUDES) $(OPTIONS)
#nvcc $< vecmultKernel00.o -o $@ $(LIB) $(INCLUDES) $(OPTIONS) -arch=sm_13

high_resolution_power.o:  high_resolution_power.cu high_resolution_power.h
	$(CC) $< ${OPTIONS} -c -o $@

clean : 
	rm -f *.o $(EXECS)

version : 
	nvcc --version

ptxx	:	vecmultKernel00.cu
	nvcc -ptx ${OPTIONS} $<
