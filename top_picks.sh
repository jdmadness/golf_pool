#!/bin/sh

if [ $# -lt 1 ]
then
  echo "Usage: $0 <tourney>"
  exit
fi

# parameters
TOURNEY=$1

# dirs and files
INSTALL_DIR="/Users/marshalj/test/golf_pool"
ENTRIES_DIR="$INSTALL_DIR/entries/$TOURNEY"

FILES=`ls $ENTRIES_DIR/*txt`
cat $FILES | sort | uniq -c | sort -nrk 1

#| awk '{ names[i%10, $0]++; i++ } END { for(combined in names){ split(combined, separate, SUBSEP); print separate[1]+1 "," separate[2] "," names[separate[1], separate[2]] }}' | sort -t "," -nk 1 | grep "^10 " | sort -t "," -nrk 3
