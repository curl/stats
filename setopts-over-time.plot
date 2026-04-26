# SVG output
load "stats/terminal.include"

# title
set title "easy setopt options" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of options"
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/setopts-over-time.csv' using 1:2 with lines linestyle 1 title ""
