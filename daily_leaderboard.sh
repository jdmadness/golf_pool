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

# get each entrant's scores
TMP_RESULTS=$RESULTS_DIR/.LeaderboardDay$DAY.txt
touch $TMP_RESULTS
for ENTRY in `find $SCORES_DIR -type f`
do
  NAME=`basename $ENTRY .txt`
  TOTAL=`fgrep Total $ENTRY | cut -d , -f $((DAY+1))`
  TB=`fgrep TB$DAY $ENTRY | cut -d, -f2-`
  echo "$NAME $TOTAL $TB" >> $TMP_RESULTS
done

# sort results
RESULTS=$RESULTS_DIR/LeaderboardDay$DAY.txt
cat $TMP_RESULTS | sort -nk 2 > $RESULTS

# clean up
rm -f $TMP_RESULTS
