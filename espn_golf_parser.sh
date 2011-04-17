#!/bin/sh

awk '/<tr class="(even|odd)row player/ {
     if($0 ~ /CUT/) {
          cut = 1
     }

     idx = index($0, "lang=\"EN\">")
     idx2 = index(substr($0, idx, 100), "</a>")
     player = substr($0, idx+10, idx2-11)

     idx = index($0, "round1\">")
     idx2 = index(substr($0, idx, 100),"</td>")
     rd1 = substr($0, idx+8, idx2-9)

     idx = index($0, "round2\">")
     idx2 = index(substr($0, idx, 100),"</td>")
     rd2 = substr($0, idx+8, idx2-9)

     if(cut != 1) {
          idx = index($0, "round3\">")
          idx2 = index(substr($0, idx, 100),"</td>")
          rd3 = substr($0, idx+8, idx2-9)

          idx = index($0, "round4\">")
          idx2 = index(substr($0, idx, 100),"</td>")
          rd4 = substr($0, idx+8, idx2-9)

          printf("%s,%2d,%2d,%2d,%2d\n", player, rd1, rd2, rd3, rd4)
     }
     else {
          printf("%s,%2d,%2d,--,--\n", player, rd1, rd2)
     }
}'
