# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Commit authors" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of authors"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 2
set style line 2 \
    linecolor rgb '#40c040' \
    linewidth 2
set style line 3 \
    linecolor rgb '#f0c040' \
    linewidth 2
set style line 4 \
    linecolor rgb '#40f0f0' \
    linewidth 2
set style line 5 \
    linecolor rgb '#f03030' \
    linewidth 2

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]
set xrange ["2010-01-01":]

set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/authors.csv' using 1:3 with lines linestyle 1 title "All", \
 'tmp/authors.csv' using 1:2 with lines linestyle 2 title "Single commit", \
 'tmp/authors.csv' using 1:7 with lines linestyle 3 title "2+ commits", \
 'tmp/authors.csv' using 1:6 with lines linestyle 4 title "5+ commits", \
 'tmp/authors.csv' using 1:5 with lines linestyle 5 title "10+ commits"
