# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Added LOC per LOC still present\n{/*0.6in product code only}" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Multiplier"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set grid
unset border
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# start Y at 1
set yrange [1:]
set xrange ["2000-03-01":]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.15 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/added-per-line.csv' using 1:2 with lines linestyle 1 title ""
