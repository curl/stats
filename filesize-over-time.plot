# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Lines per C file" font ",48"
# where's the legend
set key top right

# Identify the axes
#set xlabel "Time"
set ylabel "Number of lines in .c source files"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 3

set style line 2 \
    linecolor rgb '#00c0ad' \
    linetype 1 linewidth 3

set style line 3 \
    linecolor rgb '#ff404d' \
    linetype 1 linewidth 3

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]
set xrange ["2002-01-01":]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror
set datafile separator ";"
plot 'tmp/filesize-over-time.csv' using 1:2 with lines linestyle 1 title "largest", \
 'tmp/filesize-over-time.csv' using 1:3 with lines linestyle 2 title "p90", \
 'tmp/filesize-over-time.csv' using 1:4 with lines linestyle 3 title "median"
