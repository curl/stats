# SVG output
load "stats/terminal.include"

# title
set title "Number of words" font ",48"
# where's the legend
set key bottom right

# Identify the axes
#set xlabel "Time"
set ylabel "Number of words"

set style line 1 \
    linecolor rgb '#a06000' \
    linetype 1 linewidth 3

set style line 2 \
    linecolor rgb '#a060f0' \
    linetype 1 linewidth 3

set style line 3 \
    linecolor rgb '#0060f0' \
    linetype 1 linewidth 3

set style line 4 \
    linecolor rgb '#f04040' \
    linetype 1 linewidth 3

set grid
unset border

# time formatted using this format
set timefmt "%Y-%m-%d"
set xdata time

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set format y "%.0s%c"

set xtics rotate 3600*24*365.25 nomirror out
set ytics nomirror
unset mxtics
set datafile separator ";"
plot ARG1.'/words-over-time.csv' using 1:2 with lines linestyle 1 title "curl code base including comments", \
  587000 with lines linestyle 2 title "War and Peace", \
  481103 with lines linestyle 3 title "Lord of the Rings trilogy", \
  783137 with lines linestyle 4 title "The King James Version of the Bible"
