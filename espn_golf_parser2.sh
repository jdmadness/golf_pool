#!/bin/sh

awk '
BEGIN {
  start = 0
}

function scrub(val) {
  if(val == "-") {
    return "--"
  }
  else {
    return val
  }
}

{
  if ($0 ~ /<div class=\"leaderboard-header\"/) {
    start = 1
    next
  }

  if (start == 0) {
    next
  }

  if ($0 ~ /<td class=\"player\">/) {
    # skip to player name line
    getline

    idx = index($0, "\">")
    idx2 = index(substr($0, idx, 100), "</a>")
    player = substr($0, idx+2, idx2-3)
  
    # skip next 3 lines
    getline
    getline
    getline

    getline
    str = $0
    idx = index(str, "textcenter\">")
    idx2 = index(substr(str, idx, 100),"</td>")
    rd1 = substr(str, idx+12, idx2-13)

    getline
    str = $0
    idx = index(str, "textcenter\">")
    idx2 = index(substr(str, idx, 100),"</td>")
    rd2 = substr(str, idx+12, idx2-13)
  
    getline
    str = $0
    idx = index(str, "textcenter\">")
    idx2 = index(substr(str, idx, 100),"</td>")
    rd3 = substr(str, idx+12, idx2-13)

    getline
    str = $0
    idx = index(str, "textcenter\">")
    idx2 = index(substr(str, idx, 100),"</td>")
    rd4 = substr(str, idx+12, idx2-13)

    printf("%s,%s,%s,%s,%s\n", player, scrub(rd1), scrub(rd2), scrub(rd3), scrub(rd4))
  }
}'
