#!/bin/sh

if [ $# -lt 3 ]
then
     echo "Usage: $0 <tourney_dir> <round> <topN>"
     exit
fi

ENTRY_DIR=$1
ROUND=$2
N=$3

echo "Running for $1 (Round $2) using the top $3 scores each day"

INSTALL_DIR="/Users/marshalj/test/golf_pool"

echo "Getting scores..."
$INSTALL_DIR/get_scores.sh $ENTRY_DIR
echo "Calculating entrant scores..."
$INSTALL_DIR/calc_totals.sh $N
echo "Computing daily results..."
$INSTALL_DIR/daily_leaderboard.sh $ROUND
echo "Computing overall results..."
$INSTALL_DIR/overall_leaderboard.sh $ROUND
