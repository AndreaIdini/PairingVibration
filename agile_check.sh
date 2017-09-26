#!/bin/bash

function check {
  diff buffer.check .buffer_${2}old.check > err.check
  diff $1 .${1%.*}_${2}old.check >> err.check

  if [ `wc -m < err.check` -eq 0 ]
     then
     echo "check ok!"
     cp $1 .${1%.*}_${2}old.check
     mv buffer.check .buffer_${2}old.check
  else
    echo "check FAILED!"
    echo "Do you want to substitute checkfiles? [Y/n]"
    read checkvar
    if [ "$checkvar" == "Y" ]
       then
       echo "substituting"
       cp $1 .${1%.*}_${2}old.check
       mv buffer.check .buffer_${2}old.check   
    fi 
    exit
  fi
  #FI
}

BIN="PairVibrations.x"
FILECHK="Factors.dat"

echo "running Consistency Check..."
make

./${BIN} > buffer.check <<< '1'

check $FILECHK '1'

./${BIN} > buffer.check <<< '2'
check $FILECHK '2'

#IF [.buffer_old.check exists and .Factors_old.check exists]
#
