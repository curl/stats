# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Vulnerability reports high vs low" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "CVEs reported within that year"

# for the boxes
set boxwidth 0.6 relative
set style fill solid 0.8

set grid ytics mytics
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

dayoffset = '90'

set xtics rotate 3600*24*365.25 nomirror out
set mytics 5
set xrange ["1998-01-01":]
set mxtics 1
set ytics nomirror

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

# plot the flaw periods and the project age with titles and line width 3
plot 'tmp/sev-per-year.csv' using 1:2 with boxes title "Low or Medium severity" fc '#808000', \
  'tmp/sev-per-year.csv' using (strcol(1)[1:8].dayoffset):3 with boxes title "High or Critical severity" fc '#800000'