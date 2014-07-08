#!/bin/bash



TW_STEP_SCALE=2
BLOCK_STEP_SCALE=2

S_STEP_SCALE=2
T_STEP_SCALE=2


FILE_NAME="jacobi.h"
#EXE="SW_A"


COUNT=0
COUNT_ERROR=0
COUNT_OTHER_ERROR=0


LOG=run.log
LOG_PREFIX=JACOBI_

export NVML_REPS=30
export NVML_SLEEP_TIME=25

echo "=================================================================================================================" >> $LOG

#rm $FILE_NAME
#cp $FILE_NAME.P $FILE_NAME

for ((ts=256; ts<=8192; ts=ts*$TW_STEP_SCALE))
do 
	for ((bs=32; bs<=1024; bs=bs*$BLOCK_STEP_SCALE))
	do 
    ((RATIO=$ts/$bs))
    if [ ! $RATIO -eq 8 ];
    then
      echo "$ts/$bs != 8, continue" >> $LOG 
      continue;
    fi


		for ((ss=10240; ss<=327680; ss=ss*$S_STEP_SCALE))
		do 
      echo "ss $ss"
			for ((tt=ss*2; tt<=ss*8; tt=tt*$T_STEP_SCALE))
			do 
				echo "$ts $bs $ss $tt" >> $LOG
				echo "$ts $bs $ss $tt" 
				((SM=3*4*$ts))
        echo "$SM"
        echo "sm: $SM" >> $LOG
				if [ $SM -gt 49152 ]; 
				then 
          echo "$SM Continue"
          echo "$SM Continue" >> $LOG
          continue;
        fi

        LOG_PREFIXX=$LOG_PREFIX.$ts.$bs.$ss.$tt
    
				rm $FILE_NAME
				cp $FILE_NAME.P $FILE_NAME
				
				sed -i "s/BLOCK_WIDTH_BLOCK_WIDTH/$bs/g" $FILE_NAME
				sed -i "s/TILE_SIZE_TILE_SIZE/$ts/g" $FILE_NAME
				
				make clean
				echo "building"
				make all &> $LOG_PREFIXX.compile.log
				echo "build done"
				jacobi1D $ss $tt &> $LOG_PREFIXX.exec.log
				echo "exe done"
   
			done 
		done	
	done
done

