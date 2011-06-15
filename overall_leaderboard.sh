#!/bin/sh

if [ $# -lt 2 ]
then
     echo "Usage: $0 <tourney> <day>"
     exit
fi

# parameters
TOURNEY=$1
DAY=$2

# dirs and files
INSTALL_DIR="/Users/marshalj/test/golf_pool"
ENTRIES_DIR="$INSTALL_DIR/entries/$TOURNEY"
SCORES_DIR="$INSTALL_DIR/scores/$TOURNEY"
RESULTS_DIR="$INSTALL_DIR/leaderboard/$TOURNEY"

# get each entrant's daily results
TMP_RESULTS=$RESULTS_DIR/.OverallRd$DAY.txt
RESULTS=$RESULTS_DIR/OverallRd$DAY.txt
touch $TMP_RESULTS
for ENTRY in `find $ENTRIES_DIR -type f`
do
     NAME=`basename $ENTRY .txt`
     acc=0
     for ((a=1; a <= DAY ; a++))
     do
          val=`fgrep Rd$a $SCORES_DIR/${NAME}_day_totals.txt | cut -d , -f2`
          acc=`expr $acc + $val`
     done
     TB=`fgrep Rd$DAY $SCORES_DIR/${NAME}_overall_tiebreaker.txt | cut -d , -f2`
     echo "$NAME $acc $TB" >> $TMP_RESULTS
done

# sort results
cat $TMP_RESULTS | sort -nk 2 > $RESULTS

# clean up
rm -f $TMP_RESULTS
