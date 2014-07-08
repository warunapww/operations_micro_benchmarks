#!/bin/bash

set -o nounset
#set -o errexit

REPS=4000000

TW_STEP_SCALE=16
BLOCK_STEP_SCALE=16

FILE_NAME="vecmultKernel.h"

EXE_NAME=vecmult00
CODE_GEN_EXE_NAME=vecmultCodeGen

COUNT=0


LOG_PREFIX=float_mult_add_vecmult_
LOG=${LOG_PREFIX}.run.log

echo "0"

echo "=================================================================================================================" >> $LOG

for ((x=15; x>=5; x=x-1))
do 
      LOG_PREFIXX=$LOG_PREFIX.$x

      #rm $FILE_NAME vecmultKernel00.cu
      cp $FILE_NAME.P $FILE_NAME
      
    #  sed -i "s/__GridWidth__/$ts/g" $FILE_NAME
    #  sed -i "s/__BlockWidth__/$bs/g" $FILE_NAME
      sed -i "s/__ValuesPerThread__/${x}/g" $FILE_NAME
      sed -i "s/__k__/${REPS}/g" $FILE_NAME

      ${CODE_GEN_EXE_NAME} ${x} ${REPS} > vecmultKernel00.cu
      echo "4"
      make clean
      echo "building"
      make  &> $LOG_PREFIXX.compile.log
      echo "build done"
  for ((ts=16; ts<=256; ts=ts+$TW_STEP_SCALE))
  do 

    for ((bs=16; bs<=1024; bs=bs+$BLOCK_STEP_SCALE))
    do 
      echo "$ts $bs $x" >> $LOG
      echo "$ts $bs $x" 

      LOG_PREFIXX=$LOG_PREFIX.$ts.$bs.$x
      #LOG_PREFIXX=$LOG_PREFIX.$x


      
      Y=$(bc -l <<< "${ts}*${bs}*${x}/48128")

      #Z=$(bc -l <<< "l(${Y})/l(2)<0")
      FACTOR=$(bc -l <<< "(${Y} + l(${Y})/l(2) - 1)/2")
      Z=$(bc -l <<< "${FACTOR}<1")

      if [[ "${Z}" -eq 0 ]]
      then
        FACTOR=$(bc -l <<< "(${Y} + l(${Y})/l(2) - 1)/2")
        ACTUAL_REPS=`bc <<< ${REPS}/${FACTOR}`

        #rm $FILE_NAME vecmultKernel00.cu
        cp $FILE_NAME.P $FILE_NAME
        
      #  sed -i "s/__GridWidth__/$ts/g" $FILE_NAME
      #  sed -i "s/__BlockWidth__/$bs/g" $FILE_NAME
        sed -i "s/__ValuesPerThread__/${x}/g" $FILE_NAME
        sed -i "s/__k__/${ACTUAL_REPS}/g" $FILE_NAME

        echo "${ACTUAL_REPS}"
        ${CODE_GEN_EXE_NAME} ${x} ${ACTUAL_REPS} > vecmultKernel00.cu
        echo "4"
        make clean
        echo "building"
        make  &> $LOG_PREFIXX.compile.log
        echo "build done"

      fi

      echo "2"

      

      ${EXE_NAME} ${ts} ${bs} &> $LOG_PREFIXX.exec.log
      echo "exe done"
    done 
	done
done

TW_STEP_SCALE=13

for ((x=15; x>=5; x=x-1))
do 
      LOG_PREFIXX=$LOG_PREFIX.$x

      #rm $FILE_NAME vecmultKernel00.cu
      cp $FILE_NAME.P $FILE_NAME
      
    #  sed -i "s/__GridWidth__/$ts/g" $FILE_NAME
    #  sed -i "s/__BlockWidth__/$bs/g" $FILE_NAME
      sed -i "s/__ValuesPerThread__/${x}/g" $FILE_NAME
      sed -i "s/__k__/${REPS}/g" $FILE_NAME

      ${CODE_GEN_EXE_NAME} ${x} ${REPS} > vecmultKernel00.cu
      echo "4"
      make clean
      echo "building"
      make  &> $LOG_PREFIXX.compile.log
      echo "build done"
  for ((ts=13; ts<=260; ts=ts+$TW_STEP_SCALE))
  do 

    for ((bs=16; bs<=1024; bs=bs+$BLOCK_STEP_SCALE))
    do 
      echo "$ts $bs $x" >> $LOG
      echo "$ts $bs $x" 

      LOG_PREFIXX=$LOG_PREFIX.$ts.$bs.$x
      #LOG_PREFIXX=$LOG_PREFIX.$x


      
      Y=$(bc -l <<< "${ts}*${bs}*${x}/48128")

      #Z=$(bc -l <<< "l(${Y})/l(2)<0")
      FACTOR=$(bc -l <<< "(${Y} + l(${Y})/l(2) - 1)/2")
      Z=$(bc -l <<< "${FACTOR}<1")

      if [[ "${Z}" -eq 0 ]]
      then
        FACTOR=$(bc -l <<< "(${Y} + l(${Y})/l(2) - 1)/2")
        ACTUAL_REPS=`bc <<< ${REPS}/${FACTOR}`

        #rm $FILE_NAME vecmultKernel00.cu
        cp $FILE_NAME.P $FILE_NAME
        
      #  sed -i "s/__GridWidth__/$ts/g" $FILE_NAME
      #  sed -i "s/__BlockWidth__/$bs/g" $FILE_NAME
        sed -i "s/__ValuesPerThread__/${x}/g" $FILE_NAME
        sed -i "s/__k__/${ACTUAL_REPS}/g" $FILE_NAME

        echo "${ACTUAL_REPS}"
        ${CODE_GEN_EXE_NAME} ${x} ${ACTUAL_REPS} > vecmultKernel00.cu
        echo "4"
        make clean
        echo "building"
        make  &> $LOG_PREFIXX.compile.log
        echo "build done"

      fi

      echo "2"

      

      ${EXE_NAME} ${ts} ${bs} &> $LOG_PREFIXX.exec.log
      echo "exe done"
    done 
	done
done


