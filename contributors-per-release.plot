# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Contributors in RELEASE NOTES" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of humans who contributed to the release"

set style line 1 \
    linecolor rgb '#00608d' \
    linetype 1 linewidth 4

set style line 2 \
    linecolor rgb '#808080' \
    dt 1 linewidth 1

set grid
unset border

set yrange [0:]
set xrange ["2005-01-01":]

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set xtics rotate 3600*24*365.25 nomirror
set ytics nomirror
unset mxtics
set xrange ["2005-01-01":]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

plot  'tmp/contributors-per-release.csv' using 1:3 with lines linestyle 1 title "median over 7 releases ", \
 'tmp/contributors-per-release.csv' using 1:2 with lines linestyle 2 title "Per release"
