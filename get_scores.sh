#!/bin/sh

if [ $# -lt 1 ]
then
     echo "Usage: $0 <tourney>"
     exit
fi

# get params
TOURNEY=$1

# dirs and files
if [ ! -n $GOLF_INSTALL_DIR ]
then
     GOLF_INSTALL_DIR="/Users/marshalj/test/golf_pool"
fi
URL="http://scores.espn.go.com/golf/leaderboard"
PARSER="$GOLF_INSTALL_DIR/espn_golf_parser.sh"
DATA_DIR="$GOLF_INSTALL_DIR/data/$TOURNEY"
TMP_SCORES="$DATA_DIR/.leaderboard.txt"
WITHDRAWS="$DATA_DIR/withdraws.txt"
ALLSCORES="$DATA_DIR/leaderboard.txt"
ENTRY_DIR="$GOLF_INSTALL_DIR/entries/$TOURNEY"
SCORES_DIR="$GOLF_INSTALL_DIR/scores/$TOURNEY"

mkdir -p $DATA_DIR
mkdir -p $SCORES_DIR

# get data from website
curl -s $URL | $PARSER | sed 's/\*//' | sed 's/&#39;/`/' > $TMP_SCORES

if [ -e $WITHDRAWS ]
then
  cat $TMP_SCORES $WITHDRAWS > $ALLSCORES
  rm -f $TMP_SCORES
else
  mv $TMP_SCORES $ALLSCORES
fi

# for testing
#cat $GOLF_INSTALL_DIR/data/example.html | $PARSER | sed 's/\*//' | sed 's/&#39;/`/' > $ALLSCORES

# get each entrant's scores
for ENTRY in `find $ENTRY_DIR -type f`
do
     NAME=`basename $ENTRY .txt`
     fgrep -f $ENTRY $ALLSCORES > $SCORES_DIR/$NAME.txt
done
