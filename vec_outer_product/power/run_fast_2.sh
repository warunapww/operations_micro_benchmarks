#!/bin/bash

set -o nounset
#set -o errexit

export NVML_REPS=50
export NVML_SLEEP_TIME=25


cd ../../vecadd/power/
EXE_NAME=pp_dynamic_access_offchip_memory
LOG_PREFIX=pp_dynamic_access_offchip_memory_vecadd_
LOG=${LOG_PREFIX}.run.log

LOG_PREFIXX=$LOG_PREFIX.208.1024.1680
${EXE_NAME} 1680 &> $LOG_PREFIXX.power.log

cd ../../vec_outer_product/power/


CONFIG_FILE=configs.info

FILE_NAME="vecmultKernel.h"

EXE_NAME=vecmult00
CODE_GEN_EXE_NAME=vecmultCodeGen


LOG_PREFIX=float_mult_add_vecmult_
LOG=${LOG_PREFIX}.run.log

echo "0"

echo "=================================================================================================================" >> $LOG


while read TB TPB REPS X TIME
do
#    name=$line
    echo "Text read from file - ${TB} : ${TPB} : ${REPS} : ${X}"
    LOG_PREFIXX=$LOG_PREFIX.${TB}.${TPB}.${REPS}.${X}

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
    
done < ${CONFIG_FILE}


