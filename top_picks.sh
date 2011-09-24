#!/bin/sh

if [ $# -lt 2 ]
then
  echo "Usage: $0 <tourney> <N>"
  exit
fi

# parameters
TOURNEY=$1
N=$2

# dirs and files
if [ ! -n $GOLF_INSTALL_DIR ]
then
     GOLF_INSTALL_DIR="/Users/marshalj/test/golf_pool"
fi
HELPER="$GOLF_INSTALL_DIR/top_picks_helper.sh"
ENTRIES_DIR="$GOLF_INSTALL_DIR/entries/$TOURNEY"

FILES=`ls $ENTRIES_DIR/*txt`
for ((i=1; i <= N ; i++))
do
  echo "Group $i picks:"
  find $FILES -name "*.txt" -exec $HELPER {} $i ";" | sort | uniq -c | sort -nrk 1
done
