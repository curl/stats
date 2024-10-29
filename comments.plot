# SVG output
set terminal svg size 1920,1080 dynamic font ",24"
set title "Source code comment share" font ",48"
set key bottom right

# Identify the axes
set ylabel "Percent of lines that are comments"

set ytics nomirror
set xtics rotate 3600*24*365.25 nomirror
unset mxtics

set style line 1 \
    linecolor rgb '#00a06d' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set yrange [0:]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/comments.csv' using 2:7 with lines linestyle 1 title ""
