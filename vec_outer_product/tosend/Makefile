###
### CS575 and CS575dl Spring 2011
### Wim Bohm, instructor
### Makefile for CUDA1 assignment
### By Wim Bohm and David Newman
### Created: 2011-01-27 DVN
### Last Modified: 2011-03-05 DVN
###
### David Newman for HW4 2011-03-28
###


##
## Create variables for use below
##
#CUDA_INSTALL_PATH := /usr/local/cuda4
SDK_INSTALL_PATH :=  /usr/local/cuda4/sdk/C
LIB       :=  -L$(SDK_INSTALL_PATH)/lib  -lcutil_x86_64
INCLUDES  :=  -I$(SDK_INSTALL_PATH)/common/inc
OPTIONS   :=  -O3 --maxrregcount=124 --ptxas-options -v
#OPTIONS   :=  -O3 --maxrregcount=100 --ptxas-options -v

##
## Create variables for use below
##
#CUDA_INSTALL_PATH := /usr/local/cuda
## CUDA_INSTALL_PATH := /usr/local/cuda/bin
#SDK_INSTALL_PATH :=  /usr/local/cuda
## SDK_INSTALL_PATH :=  /usr/local/cuda/bin
#LIB       :=  -L$(SDK_INSTALL_PATH)/lib64 -L$(SDK_INSTALL_PATH)/samples/common/lib/linux/x86_64
#INCLUDES  :=  -I$(SDK_INSTALL_PATH)/include -I$(SDK_INSTALL_PATH)/samples/common/inc
#OPTIONS   :=  -O3 --maxrregcount=100 --ptxas-options -v

EXECS :=  vecmultCodeGen vecmult00
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

vecmult00 : vecmult.cu vecmultKernel.h vecmultKernel00.o
	nvcc $< vecmultKernel00.o -o $@ $(LIB) $(INCLUDES) $(OPTIONS)
	#nvcc $< vecmultKernel00.o -o $@ $(LIB) $(INCLUDES) $(OPTIONS) -arch=sm_13

clean : 
	rm *.o $(EXECS)

version : 
	nvcc --version
