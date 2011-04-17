#!/bin/sh

if [ $# -lt 2 ]
then
     echo "Usage: $0 <day> <topN>"
     exit
fi

echo "Running for Day $1 for the top $2 scores each day"

INSTALL_DIR="/Users/marshalj/test/golf_pool"

echo "Getting scores..."
$INSTALL_DIR/get_scores.sh
echo "Calculating entrant scores..."
$INSTALL_DIR/calc_totals.sh $2
echo "Computing daily results..."
$INSTALL_DIR/daily_leaderboard.sh $1
echo "Computing overall results..."
$INSTALL_DIR/overall_leaderboard.sh $1
