#!/bin/bash

LOG=run_process_logs.log
LOG_PREFIX=float_vecmult_multiply

ENERGY_LOG=${LOG_PREFIX}_ENERGY.log

echo "TB BLOCK_SIZE REPS X EXEC_TIME(ms) ENERGY(mJ) GFLOPS" > ${ENERGY_LOG}

EXEC_TIME=0
GFLOPS=0

CONFIG_FILE=configs.info

echo "=================================================================================================================" >> $LOG

while read TB TPB REPS X TIME
do
    echo "Text read from file - ${TB} : ${TPB} : ${REPS} : ${X}"
    LOG_PREFIXX=$LOG_PREFIX.${TB}.${TPB}.${REPS}.${X}
#float_mult_add_vecmult_.52.896.2323944.3.exec.log
    CURRENT_INPUT_LOG_FILE=${LOG_PREFIXX}.exec.log
    
    EXEC_TIME=`grep "#Kernel execution time: " $CURRENT_INPUT_LOG_FILE | sed -e 's/[^[0-9*\.0-9]*//g'`
    #GFLOPS=`grep "GFLOPS is " $CURRENT_INPUT_LOG_FILE | sed -e 's/[^[0-9*\.]*//g'`
    GFLOPS=`grep "GFLOPS" $CURRENT_INPUT_LOG_FILE | sed -e 's/.*GFLOPS: //g' | sed -e 's/GBytesS.*//g'`
   
    ENERGY=`sh compute_energy.sh ${CURRENT_INPUT_LOG_FILE}`

    #echo "${ts_prev} ${bs_prev} ${ss_prev} ${tt_prev} ${EXEC_TIME} ${ENERGY} ${GFLOPS}" >> ${ENERGY_LOG}
    echo "${TB} ${TPB} ${REPS} ${X} ${EXEC_TIME} ${ENERGY} ${GFLOPS}" >> ${ENERGY_LOG}
done < ${CONFIG_FILE}


