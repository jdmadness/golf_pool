#!/bin/sh

if [ $# -lt 1 ]
then
     echo "Usage: $0 <tourney>"
     exit
fi

# get params
TOURNEY=$1

# dirs and files
INSTALL_DIR="/Users/marshalj/test/golf_pool"
URL="http://scores.espn.go.com/golf/leaderboard"
PARSER="$INSTALL_DIR/espn_golf_parser2.sh"
DATA_DIR="$INSTALL_DIR/data/$TOURNEY"
TMP_SCORES="$DATA_DIR/.leaderboard.txt"
WITHDRAWS="$DATA_DIR/withdraws.txt"
ALLSCORES="$DATA_DIR/leaderboard.txt"
ENTRY_DIR="$INSTALL_DIR/entries/$TOURNEY"
SCORES_DIR="$INSTALL_DIR/scores/$TOURNEY"

mkdir -p $DATA_DIR
mkdir -p $SCORES_DIR

# get data from website
#curl -s $URL | $PARSER | sed 's/\*//' | sed 's/&#39;/`/' > $TMP_SCORES
curl -s $URL | sed 's|><|>\
<|g' | $PARSER | sed 's/\*//' | sed 's/&#39;/`/' > $TMP_SCORES

if [ -e $WITHDRAWS ]
then
  cat $TMP_SCORES $WITHDRAWS > $ALLSCORES
  rm -f $TMP_SCORES
else
  mv $TMP_SCORES $ALLSCORES
fi

# for testing
#cat $INSTALL_DIR/data/example.html | $PARSER | sed 's/\*//' | sed 's/&#39;/`/' > $ALLSCORES

# get each entrant's scores
for ENTRY in `find $ENTRY_DIR -type f`
do
     NAME=`basename $ENTRY .txt`
     fgrep -f $ENTRY $ALLSCORES > $SCORES_DIR/$NAME.txt
done
