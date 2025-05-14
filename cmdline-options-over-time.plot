# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Command line options" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of options"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate out
set ytics 25 nomirror
unset mxtics

load "stats/config.plot"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/cmdline-options-over-time.csv' using 1:2 with lines linestyle 1 title ""
