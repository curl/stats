# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Authors per month" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Authors"

# for the boxes
set boxwidth 0.6 relative
set style fill solid

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
set ytics nomirror
unset mxtics

set xrange ["2010-01-01":]
set yrange [0:]

set style line 2 \
    linecolor rgb '#ff60ad' \
    dt 1 linewidth 4

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot  'tmp/authors-per-month.csv' using 1:2 with boxes fc "#60a060" title "Authors",\
 'tmp/authors-per-month.csv' using 1:3 with lines linestyle 2 title "12 month average"
