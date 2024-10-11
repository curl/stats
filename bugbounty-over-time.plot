# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Accumulated curl bug-bounty payouts since 2018" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "USD"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 2 pointsize 0.3 \
    pointtype 7

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate out
unset mxtics
set ytics nomirror

# start Y at 0
set yrange [0:]
set xrange ["2018-01-01":]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/bugbounty-over-time.csv' using 2:3 with linespoints linestyle 1 title ""
