# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "First time commit authors" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Authors per month"

set style line 1 \
    linecolor rgb '#c0c0ff' \
    linetype 1 linewidth 2

set style line 2 \
    linecolor rgb '#80a040' \
    dt 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set boxwidth 0.8 relative
set style fill solid

load "stats/config.plot"



# set the format of the dates on the x axis
set format x "%Y"
set xrange ["2010-01-01":]
set xtics rotate 3600*24*365.25 nomirror out
set datafile separator ";"
plot 'tmp/firsttimers.csv' using 1:2 with boxes linestyle 1 title "First timers", \
 'tmp/firsttimers.csv' using 1:3 with lines linestyle 2 title "12 month average"
