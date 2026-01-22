# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Easy handle struct size" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Size in bytes"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]

set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'stats/easy-handle.csv' using 2:3 with lines linestyle 1 title ""
