#!/bin/sh

awk '
function scrub(val) {
  if(val == " - ") {
    return "--"
  }
  else {
    return val
  }
}

/<tr class="(even|odd)row player/ {
  idx = index($0, "lang=\"EN\">")
  idx2 = index(substr($0, idx, 100), "</a>")
  player = substr($0, idx+10, idx2-11)

  str = $0
  idx = index(str, "round1\">")
  idx2 = index(substr(str, idx, 100),"</td>")
  rd1 = substr(str, idx+8, idx2-9)

  str = substr($0, idx+idx2+4, 100)
  idx = index(str, ">")
  idx2 = index(substr(str, idx, 100),"</td>")
  rd2 = substr(str, idx+1, idx2-2)

  str = substr(str, idx+idx2+4, 100)
  idx = index(str, ">")
  idx2 = index(substr(str, idx, 100),"</td>")
  rd3 = substr(str, idx+1, idx2-2)

  str = substr(str, idx+idx2+4, 100)
  idx = index(str, ">")
  idx2 = index(substr(str, idx, 100),"</td>")
  rd4 = substr(str, idx+1, idx2-2)

  printf("%s,%s,%s,%s,%s\n", player, scrub(rd1), scrub(rd2), scrub(rd3), scrub(rd4))
}'
