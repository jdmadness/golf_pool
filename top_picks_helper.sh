#!/bin/sh

if [ $# -lt 2 ]
then
  echo "Usage: $0 <file> <N>"
  exit
fi

# parameters
FILE=$1
N=$2

head -n $N $FILE | tail -n 1
