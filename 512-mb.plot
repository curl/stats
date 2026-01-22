# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "512MB download alloc spend" font ",48"
# where's the legend
set key bottom right

# Identify the axes
#set xlabel "Time"
set ylabel "Total amount of allocations in bytes" tc "#0060ad"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 4

set style line 2 \
    linecolor rgb '#40c040' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]
set y2range [0:]

set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror

set y2label "Number of allocations" tc "#40c040"
set y2tics
set ytics nomirror

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set format y "%.0s%c"
set datafile separator ";"
plot 'stats/512-mb.csv' using 2:4 with lines linestyle 1 title "Total amount of memory used", \
 'stats/512-mb.csv' using 2:3 axis x1y2 with lines linestyle 2 title "Number of allocations"
