# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Transfer protocols" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of protocols"
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 2 \
    pointtype 6

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set yrange [0:]

load "stats/config.plot"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/protocols-over-time.csv' using 1:3 with linespoints linestyle 1 title "", 'tmp/protocols-over-time.csv' using 1:3:2 with labels right rotate by -22 offset -.5,0.2 font ",18" tc "#ff0000" title ""
