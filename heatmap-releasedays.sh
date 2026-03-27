#!/bin/sh
# Generate calendar.csv as input data for heatmap
curl -s https://curl.se/docs/releases.csv |\
awk -F';' '{print $4}' |\
while read -r d; do
  wday=$(date -d "$d" +%u)   # 1=Mon..7=Sun
  week=$(date -d "$d" +%V)   # ISO week 01..53
  printf "%s,%s,%s\n" "$d" "$week" "$wday"
done |\
awk -F',' '{ key=$2","$3; c[key]++ }
  END {for (k in c) print k","c[k]}' |\
sort -t, -k1,1n -k2,2n
