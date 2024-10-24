# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Commits per day of year" font ",48"
# where's the legend
set key top center

# Identify the axes
#set xlabel "Time"
set ylabel "Commits done on the specific date"

# for the boxes
set boxwidth 0.6 relative
set style fill solid

set grid
unset border

# time formated using this format
set timefmt "%m-%d"
set xdata time

set xrange ["01-01":"12-31"]

set xtics 3600*24*30.44 nomirror out offset 4
set ytics out nomirror
unset mxtics

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%B"
set datafile separator ";"

plot 'tmp/date-of-year.csv' using 1:2 with boxes fc "#800080" title ""
