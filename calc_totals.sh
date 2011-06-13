#!/bin/sh

if [ $# -lt 1 ]
then
     echo "Usage: $0 <topN>"
     exit
fi

# parameters
TOPN=$1

# dirs and files
INSTALL_DIR="/Users/marshalj/test/golf_pool"
ALLSCORES="$INSTALL_DIR/tmp_data/leaderboard.txt"
SCORES_DIR="$INSTALL_DIR/scores"
RESULTS_DIR="$INSTALL_DIR/results"
MAXCMD="$INSTALL_DIR/daily_max.sh"

# compute daily max
MAX[1]=`cat $ALLSCORES | $MAXCMD 1`
MAX[2]=`cat $ALLSCORES | $MAXCMD 2`
MAX[3]=`cat $ALLSCORES | $MAXCMD 3`
MAX[4]=`cat $ALLSCORES | $MAXCMD 4`

# compute each entrant's daily scores
for FILE in `find $SCORES_DIR -type f`
do
     NAME=`basename $FILE .txt`
     OUTFILE=$SCORES_DIR/${NAME}_tally.txt
     LINE="Total"
     TB_LINES=""
     for DAY in 1 2 3 4
     do
          DAY_TOTAL=`cut -d , -f $((DAY+1)) $FILE | sed s/--/${MAX[$DAY]}/ | sort -n | head -n $TOPN | awk '{ acc += $0 } END { print acc }'`
          LINE="$LINE,$DAY_TOTAL"
          echo "TB$DAY`cut -d , -f $((DAY+1)) $FILE | sed s/--/${MAX[$DAY]}/ | sort -n | awk '{ acc = acc "," $0 } END { print acc }'`" >> $OUTFILE
     done
     echo $LINE >> $OUTFILE
     mv $OUTFILE $FILE
done
