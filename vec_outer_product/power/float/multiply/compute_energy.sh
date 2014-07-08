#!/bin/bash

LOG=compute_area.log

date>>${LOG}

FILE=$1
echo "FILE:$FILE">>${LOG}
EXEC_TIME=`grep "#Kernel execution time: " $FILE | sed -e 's/[^[0-9*\.0-9]*//g'`
echo "EXEC_TIME: $EXEC_TIME">>${LOG}
COUNT=0

T_CURR=0
T_PREV=0
P_CURR=0
P_PREV=0

ENERGY=0

SORTED_FILE=sorted_$FILE

tail  -n +3 $FILE | head -n -11 | sort -n -k1 > $SORTED_FILE

while read line;  
do
  T_PREV=$T_CURR  
  P_PREV=$P_CURR  

#  echo "$line"
  if [[ ${line:0:1} == '#' ]]
  then
    #echo "$line"
    continue
  fi
  
  IFS=$'\t '
  read -a array <<< "$line"

  #T_CURR=`echo "$line" | sed -e 's/ .*//g'`
  T_CURR=${array[0]}
  P_CURR=${array[2]}
#  echo "TIME: $T_CURR"
 
  F_COMPARE_1=`echo $T_CURR'>'$EXEC_TIME | bc -l`
  F_COMPARE_2=`echo $T_CURR'<0' | bc -l`
 
  #if [ $F_COMPARE_1 -eq 1 -o $F_COMPARE_2 -eq 1 ]
  if [ $F_COMPARE_2 -eq 1 ]
  then
    #T_CURR is less than 0
    continue
  fi
  if [ $F_COMPARE_1 -eq 1 ]
  then
    #T_CURR is greater than EXEC_TIME
    if [ $COUNT -gt 0 ]
    then
  #    echo "COUNT > 0"
      #Just passed the EXEC_TIME. Therefore calculate the power at execution time.
      COUNT=-1
      P_CURR=`bc -l <<< "${P_CURR}-(${T_CURR}*(${P_CURR}-${P_PREV})/(${T_CURR}-(${T_PREV})))"`
      T_CURR=${EXEC_TIME};
    else  
      continue
    fi
  fi

#  echo "POWER: $P_CURR"

  if [ $COUNT -eq 0 ]
  then
    ((COUNT=$COUNT+1))
   # echo "${P_CURR}-(${T_CURR}*(${P_CURR}-${P_PREV})/(${T_CURR}-${T_PREV}))"
    P_PREV=`bc -l <<< "${P_CURR}-(${T_CURR}*(${P_CURR}-${P_PREV})/(${T_CURR}-(${T_PREV})))"`
    T_PREV=0;
    #echo "TIME ${T_PREV}, POWER ${P_PREV}"
#    continue
  fi

  ENERGY=`bc -l <<< "$ENERGY+(($P_CURR+$P_PREV)*($T_CURR-$T_PREV)/2)"`
  

done < $SORTED_FILE

rm $SORTED_FILE

echo "$ENERGY"
echo "ENERGY: $ENERGY">>${LOG}

date>>${LOG}
