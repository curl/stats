# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "strncpy density" font ",48"
# where's the legend
set key bottom center

# Identify the axes
set ylabel "strncpy functions calls in src and lib per KLOC (excl comments)"
set y2label "Total function count"
set y2tics

set style line 1 \
    linecolor rgb '#c060ad' \
    linetype 1 linewidth 3

set style line 3 \
    linecolor rgb '#ff404d' \
    linetype 1 dt "_" linewidth 1

set ytics nomirro

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
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set datafile separator ";"
plot 'tmp/strncpy-over-time.csv' using 1:3 with lines linestyle 3 title "strncpy total count" axis x1y2, \
'tmp/strncpy-over-time.csv' using 1:2 with lines linestyle 1 title "strncpy density"
