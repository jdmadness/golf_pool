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

# get each entrant's scores
RESULTS=$RESULTS_DIR/Rd${DAY}_entries.txt
touch $RESULTS
for ENTRY in `find $ENTRIES_DIR -type f`
do
  NAME=`basename $ENTRY .txt`
  echo "====$NAME====" >> $RESULTS
  cat $SCORES_DIR/$NAME.txt | sort -t"," -nk 2 >> $RESULTS
  cat $SCORES_DIR/${NAME}_day_totals.txt | cut -d , -f2 | awk 'BEGIN{ acc = "Total" } { acc = acc "," $0 } END{ print acc }' >> $RESULTS
done
