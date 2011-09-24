#!/bin/sh

if [ $# -lt 3 ]
then
  echo "Usage: $0 <tourney> <day> <topN>"
  exit
fi

# parameters
TOURNEY=$1
DAY=$2
N=$3

# dirs and files
if [ ! -n $GOLF_INSTALL_DIR ]
then
     GOLF_INSTALL_DIR="/Users/marshalj/test/golf_pool"
fi
ENTRIES_DIR="$GOLF_INSTALL_DIR/entries/$TOURNEY"
SCORES_DIR="$GOLF_INSTALL_DIR/scores/$TOURNEY"
RESULTS_DIR="$GOLF_INSTALL_DIR/leaderboard/$TOURNEY"

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
TB_START=$((3*$N+1))
cat $TMP_RESULTS | sort -nk 2 -k 3.$TB_START | awk '{ printf "%-10s\t%4d\t%s\n", $1, $2, $3 }' > $RESULTS

# clean up
rm -f $TMP_RESULTS
