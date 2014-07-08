
CC := nvcc
CUDA_CC	:=	$(COMPUTE_CAPABILITY)
OPTIONS := -O3 --maxrregcount=255 -Xptxas -v -arch=${CUDA_CC}
LIB := -L/s/chopin/e/proj/AlphaZ/waruna/lib -L/s/chopin/e/proj/AlphaZ/waruna/papi/installation/5.3.0/lib -lnvidia-ml -lpapi

EXECS :=  vecmultCodeGen vecmultMaxAddCodeGen vecmult00
OBJECTS	:= vecmultKernel00.o high_resolution_power.o

all:$(EXECS)

vecmultCodeGen : vecmultCodeGen.c
	gcc -o $@ $<

vecmultMaxAddCodeGen : vecmultMaxAddCodeGen.c
	gcc -o $@ $<
#######################################################################
vecmultKernel00.o : vecmultKernel00.cu
	nvcc $< -c -o $@ $(OPTIONS)

vecmult00 : vecmult.cu vecmultKernel.h vecmultKernel00.o high_resolution_power.o
	nvcc $< $(OBJECTS) -o $@ $(LIB) $(INCLUDES) $(OPTIONS)

high_resolution_power.o:	high_resolution_power.cu high_resolution_power.h
	$(CC) $< ${OPTIONS} -c -o $@

clean : 
	rm *.o $(EXECS)

c : 
	rm *.o vecmult00

version : 
	nvcc --version

ptxx	:	vecmultKernel00.cu
	nvcc -ptx $<
