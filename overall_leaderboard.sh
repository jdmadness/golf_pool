#!/bin/sh

if [ $# -lt 1 ]
then
     echo "Usage: $0 <day>"
     exit
fi

# parameters
DAY=$1

# dirs and files
INSTALL_DIR="/Users/marshalj/test/golf_pool"
SCORES_DIR="$INSTALL_DIR/scores"
RESULTS_DIR="$INSTALL_DIR/results"

# get each entrant's daily results
TMP_RESULTS=$RESULTS_DIR/.OverallLeaderboardDay$DAY.txt
RESULTS=$RESULTS_DIR/OverallLeaderboardDay$DAY.txt
touch $TMP_RESULTS
if [ $DAY -eq 1 ]
then
     cp $RESULTS_DIR/LeaderboardDay1.txt $TMP_RESULTS
     cat $TMP_RESULTS | sort -nk 2 > $RESULTS
     rm -f $TMP_RESULTS
     exit
fi

for ENTRY in `find $SCORES_DIR -type f`
do
     NAME=`basename $ENTRY .txt`
     acc=0
     for ((a=1; a <= DAY ; a++))
     do
          val=`fgrep Total $ENTRY | cut -d , -f $((a+1))`
          acc=`expr $acc + $val`
     done
     echo "$NAME $acc" >> $TMP_RESULTS
done

# sort results
cat $TMP_RESULTS | sort -nk 2 > $RESULTS

# TODO - handle ties

# clean up
rm -f $TMP_RESULTS
