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

mkdir -p $RESULTS_DIR

# get each entrant's scores
TMP_RESULTS=$RESULTS_DIR/.Rd$DAY.txt
touch $TMP_RESULTS
for ENTRY in `find $ENTRIES_DIR -type f`
do
  NAME=`basename $ENTRY .txt`
  TOTAL=`fgrep Rd$DAY $SCORES_DIR/${NAME}_day_totals.txt | cut -d , -f2`
  TB=`fgrep Rd$DAY $SCORES_DIR/${NAME}_day_tiebreaker.txt | cut -d, -f2-`
  echo "$NAME $TOTAL $TB" >> $TMP_RESULTS
done

# sort results
RESULTS=$RESULTS_DIR/Rd$DAY.txt
cat $TMP_RESULTS | sort -nk 2 | awk '{ printf "%-10s\t%4d\t%s\n", $1, $2, $3 }' > $RESULTS

# clean up
rm -f $TMP_RESULTS
