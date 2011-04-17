#!/bin/sh

if [ $# -lt 1 ]
then
     echo "Usage: $0 <day>"
     exit
fi

DAY=$1

awk -F "," -v DAY=$DAY '
BEGIN {
     day = DAY + 1
}
{
     if($day > max) {
          max = $day
     }
}
END {
     print max
}'
