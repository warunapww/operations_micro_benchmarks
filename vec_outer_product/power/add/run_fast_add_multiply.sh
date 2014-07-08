#!/bin/bash

set -o nounset
#set -o errexit

export NVML_REPS=30
export NVML_SLEEP_TIME=20


CONFIG_FILE=configs.info

FILE_NAME="vecmultKernel.h"

EXE_NAME=vecmult00
CODE_GEN_EXE_NAME=vecmultCodeGen


LOG_PREFIX=float_vecmult_
LOG=${LOG_PREFIX}.run.log

echo "0"

echo "=================================================================================================================" >> $LOG


#NEXT_INPUT_LOG_FILE=pp_dynamic_access_offchip_memory_vecadd_repeat_.195.1024.46.1792.exec.log

#while true;
#do
#  if [ -a $NEXT_INPUT_LOG_FILE ]
#  then
#    sleep 1800
#    break
#  fi
#
#  echo "Waiting for file ${NEXT_INPUT_LOG_FILE}"
#  echo "Waiting for file ${NEXT_INPUT_LOG_FILE}" >> ${LOG}
#  sleep 60
#done




while read TB TPB REPS X TIME
do
#    name=$line
    echo "Text read from file - ${TB} : ${TPB} : ${REPS} : ${X}"
#--------------------------------------------------------------------
#add

    LOG_PREFIXX=${LOG_PREFIX}add.${TB}.${TPB}.${REPS}.${X}

    cp $FILE_NAME.P $FILE_NAME
    
    sed -i "s/__ValuesPerThread__/${X}/g" $FILE_NAME
    sed -i "s/__k__/${REPS}/g" $FILE_NAME
    sed -i "s/__GridWidth__/${TB}/g" $FILE_NAME
    sed -i "s/__BlockWidth__/${TPB}/g" $FILE_NAME

    ${CODE_GEN_EXE_NAME} ${X} > vecmultKernel00.cu
    echo "4"
    make clean
    echo "building"
    make  &> $LOG_PREFIXX.compile.log
    echo "build done"

    ${EXE_NAME} &> $LOG_PREFIXX.exec.log
   
#--------------------------------------------------------------------
#multiply
    cd ../multiply
    LOG_PREFIXX=${LOG_PREFIX}multiply.${TB}.${TPB}.${REPS}.${X}

    cp $FILE_NAME.P $FILE_NAME
    
    sed -i "s/__ValuesPerThread__/${X}/g" $FILE_NAME
    sed -i "s/__k__/${REPS}/g" $FILE_NAME
    sed -i "s/__GridWidth__/${TB}/g" $FILE_NAME
    sed -i "s/__BlockWidth__/${TPB}/g" $FILE_NAME

    ${CODE_GEN_EXE_NAME} ${X} > vecmultKernel00.cu
    echo "4"
    make clean
    echo "building"
    make  &> $LOG_PREFIXX.compile.log
    echo "build done"

    ${EXE_NAME} &> $LOG_PREFIXX.exec.log
    

    cd ../add
 
done < ${CONFIG_FILE}


