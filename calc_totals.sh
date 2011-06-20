#!/bin/sh

if [ $# -lt 3 ]
then
     echo "Usage: $0 <tourney> <round> <topN>"
     exit
fi

# parameters
TOURNEY=$1
DAY=$2
TOPN=$3

# dirs and files
INSTALL_DIR="/Users/marshalj/test/golf_pool"
ENTRIES_DIR="$INSTALL_DIR/entries/$TOURNEY"
ALLSCORES="$INSTALL_DIR/data/$TOURNEY/leaderboard.txt"
SCORES_DIR="$INSTALL_DIR/scores/$TOURNEY"
RESULTS_DIR="$INSTALL_DIR/results/$TOURNEY"
MAXCMD="$INSTALL_DIR/daily_max.sh"

mkdir -p $SCORES_DIR
mkdir -p $RESULTS_DIR

# compute daily max
MAX=`cat $ALLSCORES | $MAXCMD $DAY`
MAX1=`cat $ALLSCORES | $MAXCMD 1`
MAX2=`cat $ALLSCORES | $MAXCMD 2`
MAX3=`cat $ALLSCORES | $MAXCMD 3`
MAX4=`cat $ALLSCORES | $MAXCMD 4`

# compute each entrant's daily scores
for FILE in `find $ENTRIES_DIR -type f`
do
     NAME=`basename $FILE .txt`
     TMP_FILE=$SCORES_DIR/.${NAME}_tmp.txt
     PLAYER_FILE=$SCORES_DIR/$NAME.txt
     PLAYER_TOTALS_FILE=$SCORES_DIR/${NAME}_totals.txt
     DAY_TOTALS_FILE=$SCORES_DIR/${NAME}_day_totals.txt
     DAY_TB_FILE=$SCORES_DIR/${NAME}_day_tiebreaker.txt
     OVERALL_TB_FILE=$SCORES_DIR/${NAME}_overall_tiebreaker.txt

     touch $DAY_TOTALS_FILE
     touch $DAY_TB_FILE
     touch $OVERALL_TB_FILE

     # update player totals
     cat $PLAYER_FILE | awk -F"," -v MAX1=$MAX1 -v MAX2=$MAX2 -v MAX3=$MAX3 -v MAX4=$MAX4 -v DAY=$DAY 'BEGIN{ max[1] = MAX1; max[2] = MAX2; max[3] = MAX3; max[4] = MAX4; day = DAY }{ acc = 0; for(i = 2; i <= day+1; i++) { if($i == "--") { acc += max[i-1] } else { acc += $i } } print $1 "," acc}' > $TMP_FILE
     mv $TMP_FILE $PLAYER_TOTALS_FILE

     # day total
     cp $DAY_TOTALS_FILE $TMP_FILE
     echo "Rd$DAY,`cut -d , -f $((DAY+1)) $PLAYER_FILE | sed s/--/${MAX}/ | sort -n | head -n $TOPN | awk '{ acc += $0 } END { print acc }'`" >> $TMP_FILE
     cat $TMP_FILE | sort | uniq > $DAY_TOTALS_FILE

     # day tie-breaker
     cp $DAY_TB_FILE $TMP_FILE
     echo "Rd$DAY`cut -d , -f $((DAY+1)) $PLAYER_FILE | sed s/--/${MAX}/ | sort -n | awk '{ acc = acc "," $0 } END { print acc }'`" >> $TMP_FILE
     cat $TMP_FILE | sort | uniq > $DAY_TB_FILE

     # overall tie-breaker
     cp $OVERALL_TB_FILE $TMP_FILE
     echo "Rd$DAY`cat $PLAYER_TOTALS_FILE | sort -t"," -nk 2 | awk -F"," '{ acc = acc "," $2 } END { print acc }'`" >> $TMP_FILE
     cat $TMP_FILE | sort | uniq > $OVERALL_TB_FILE
    
     # clean up
     rm -rf $TMP_FILE
done
