#!/bin/sh

if [ $# -lt 3 ]
then
     echo "Usage: $0 <tourney> <round> <topN>"
     exit
fi

TOURNEY=$1
ROUND=$2
N=$3

echo "Running for $1 (Round $2) using the top $3 scores each day"

if [ ! -n $GOLF_INSTALL_DIR ]
then
     GOLF_INSTALL_DIR="/Users/marshalj/test/golf_pool"
fi

echo "Getting scores..."
$GOLF_INSTALL_DIR/get_scores.sh $TOURNEY
echo "Calculating entrant scores..."
$GOLF_INSTALL_DIR/calc_totals.sh $TOURNEY $ROUND $N
echo "Computing daily results..."
$GOLF_INSTALL_DIR/daily_leaderboard.sh $TOURNEY $ROUND $N
echo "Computing overall results..."
$GOLF_INSTALL_DIR/overall_leaderboard.sh $TOURNEY $ROUND
