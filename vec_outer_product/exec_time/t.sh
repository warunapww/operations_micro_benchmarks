#!/bin/bash

set -o nounset
set -o errexit

ts=16
bs=208
x=15

REPS=4000000





Y=$(bc -l <<< "${ts}*${bs}*${x}/48128")

#Z=$(bc -l <<< "l(${Y})/l(2)<0")
  FACTOR=$(bc -l <<< "(${Y} + l(${Y})/l(2) - 1)/2")
Z=$(bc -l <<< "${FACTOR}<1")

#if [[ "${Z}" -eq 1 ]]
if [[ "${Z}" -eq 1 ]]
then
  #FACTOR=$(bc -l <<< "(${Y})/2")
  FACTOR=1
#else
#  FACTOR=$(bc -l <<< "(${Y} + l(${Y})/l(2) - 1)/2")
fi

ACTUAL_REPS=`bc <<< ${REPS}/${FACTOR}`


echo "y: ${Y}, FACTOR: ${FACTOR}, ACTUAL_REPS: ${ACTUAL_REPS}"
