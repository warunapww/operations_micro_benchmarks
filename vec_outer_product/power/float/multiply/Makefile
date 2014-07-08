CC := nvcc
CUDA_CC :=  $(COMPUTE_CAPABILITY)
OPTIONS := -O3 --maxrregcount=255 -Xptxas -v -arch=${CUDA_CC}
OPTIONS_WO_O3 := -O1 --maxrregcount=255 -Xptxas -v -Xptxas -O1 -arch=${CUDA_CC}
LIB := -L/s/chopin/e/proj/AlphaZ/waruna/lib -L/s/chopin/e/proj/AlphaZ/waruna/papi/installation/5.3.0/lib -lnvidia-ml -lpapi

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

vecmult00 : vecmult.cu vecmultKernel.h vecmultKernel00.o high_resolution_power.o
	nvcc $< ${OBJECTS} -o $@ $(LIB) $(INCLUDES) $(OPTIONS)

high_resolution_power.o :  high_resolution_power.cu high_resolution_power.h
	$(CC) $< ${OPTIONS} -c -o $@

clean : 
	rm -f *.o $(EXECS)

version : 
	nvcc --version

ptxx	:	vecmultKernel00.cu vecmultKernel.h
	nvcc -ptx ${OPTIONS} $<

ptxxx	:	vecmultKernel00.cu
	nvcc -ptx $<
