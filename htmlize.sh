awk '
BEGIN {
  print "<style type=\"text/css\">"
  print "table.scores"
  print "{"
  print "font-family:\"Trebuchet MS\", Arial, Helvetica, sans-serif;"
  print "cellspacing:0;"
  print "cellpadding:0;"
  print "width:100%;"
  print "border:0px;"
  print "border-collapse:collapse;"
  print "}"
  print ""
  print "table.scores th"
  print "{"
  print "font-size:1.1em;"
  print "border:0px;"
  print "padding:3px 7px 2px 7px;"
  print "text-align:left;"
  print "padding-top:5px;"
  print "padding-bottom:4px;"
  print "background-color:#3afd00;"
  print "color:#ffffff;"
  print "}"
  print ""
  print "table.scores td"
  print "{"
  print "font-size:1em;"
  print "border:0px;"
  print "padding:3px 7px 2px 7px;"
  print "vertical-align:top;"
  print "background-color:#ffffff;"
  print "}"
  print ""
  print "td.pos"
  print "{"
  print "text-align:right;"
  print "}"
  print "tr.alt td"
  print "{"
  print "color:#000000;"
  print "background-color:#eaf2d3;"
  print "}"
  print "</style>"
  print ""
  print "<table class=\"scores\">" 
  print "<tr><th></th><th>Player</th><th>Score</th></tr>"
}
{
  i++
  if (i%2==0) {
    print "<tr class=\"alt\"><td class=\"pos\">" i ".</td><td>" $1 "</td><td>" $2 "</td></tr>"
  }
  else {
    print "<tr><td class=\"pos\">" i ".</td><td>" $1 "</td><td>" $2 "</td></tr>"
  }
}
END {
  print "</table>"
}'
