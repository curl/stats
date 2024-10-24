# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Function length\n{/*0.4Lines of code for the 99th percentile and worst function. Includes comments and blank lines.}" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Lines of code"

set style line 1 \
    linecolor rgb '#c04040' \
    linewidth 4
set style line 2 \
    linecolor rgb '#40c040' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
set ytics nomirror
unset mxtics

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/complexity.csv' using 1:4 with lines linestyle 2 title "P99", \
 'tmp/complexity.csv' using 1:5 with lines linestyle 1 title "Worst"
