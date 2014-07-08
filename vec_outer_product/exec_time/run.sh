#!/bin/bash

REPS=4000000

TW_STEP_SCALE=16
BLOCK_STEP_SCALE=16

FILE_NAME="vecmultKernel.h"

EXE_NAME=vecmult00
CODE_GEN_EXE_NAME=vecmultCodeGen

COUNT=0


LOG_PREFIX=float_mult_add_vecmult_
LOG=${LOG_PREFIX}.run.log


echo "=================================================================================================================" >> $LOG

for ((x=4; x<=15; x=x+1))
do 
  LOG_PREFIXX=$LOG_PREFIX.$x

  rm $FILE_NAME
  cp $FILE_NAME.P $FILE_NAME
  
#  sed -i "s/__GridWidth__/$ts/g" $FILE_NAME
#  sed -i "s/__BlockWidth__/$bs/g" $FILE_NAME
  sed -i "s/__ValuesPerThread__/${x}/g" $FILE_NAME
  sed -i "s/__k__/${REPS}/g" $FILE_NAME
  
  ${CODE_GEN_EXE_NAME} ${x} ${REPS} > vecmultKernel00.cu
  make c
  echo "building"
  make ${EXE_NAME} &> $LOG_PREFIXX.compile.log
  echo "build done"

  for ((ts=16; ts<=256; ts=ts+$TW_STEP_SCALE))
  do 

    for ((bs=16; bs<=1024; bs=bs+$BLOCK_STEP_SCALE))
    do 
      echo "$ts $bs $x" >> $LOG
      echo "$ts $bs $x" 

      LOG_PREFIXX=$LOG_PREFIX.$ts.$bs.$x

      ${EXE_NAME} ${ts} ${bs} &> $LOG_PREFIXX.exec.log
      echo "exe done"
    done 
	done
done

TW_STEP_SCALE=13

for ((x=1; x<=15; x=x+1))
do 
  LOG_PREFIXX=$LOG_PREFIX.$x

  rm $FILE_NAME
  cp $FILE_NAME.P $FILE_NAME
  
#  sed -i "s/__GridWidth__/$ts/g" $FILE_NAME
#  sed -i "s/__BlockWidth__/$bs/g" $FILE_NAME
  sed -i "s/__ValuesPerThread__/${x}/g" $FILE_NAME
  sed -i "s/__k__/${REPS}/g" $FILE_NAME
  
  ${CODE_GEN_EXE_NAME} ${x} ${REPS} > vecmultKernel00.cu;
  make c
  echo "building"
  make ${EXE_NAME} &> $LOG_PREFIXX.compile.log
  echo "build done"

  for ((ts=13; ts<=260; ts=ts+$TW_STEP_SCALE))
  do 

    for ((bs=16; bs<=1024; bs=bs+$BLOCK_STEP_SCALE))
    do 
      echo "$ts $bs $x" >> $LOG
      echo "$ts $bs $x" 

      LOG_PREFIXX=$LOG_PREFIX.$ts.$bs.$x

      ${EXE_NAME} ${ts} ${bs} &> $LOG_PREFIXX.exec.log
      echo "exe done"
    done 
	done
done

