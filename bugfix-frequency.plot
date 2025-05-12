# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Bugfixes" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Logged bugfixes"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set style line 2 \
    linecolor rgb '#ff60ad' \
    linetype 1 linewidth 3

# don't draw the left-yaxies tics on the right side
set ytics nomirror
set xtics 3600*24*365.25 nomirror rotate
unset mxtics

set y2label "Bugfixes per day" tc "#ff60ad"
set y2tics
set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

load "stats/config.plot"



# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/bugfix-frequency.csv' using 1:2 with lines linestyle 1 title "Accumulated number of bugfixes", \
 'tmp/bugfix-frequency.csv' using 1:3 with lines linestyle 2 title "Average per day over 12 months" axis x1y2