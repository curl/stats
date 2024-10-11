# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Memory function call density" font ",48"
# where's the legend
set key bottom center

# Identify the axes
set ylabel "Functions calls per KLOC (excl comments)"
set y2label "Total function count"
set y2tics

set style line 1 \
    linecolor rgb '#c060ad' \
    linetype 1 linewidth 3

set style line 2 \
    linecolor rgb '#c0c04d' \
    linetype 1 linewidth 3

set style line 3 \
    linecolor rgb '#ff404d' \
    linetype 1 dt "_" linewidth 1

set style line 4 \
    linecolor rgb '#0040ff' \
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
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set datafile separator ";"
plot 'tmp/cpy-over-time.csv' using 1:3 with lines linestyle 3 title "(mem|str|strn)cpy total count" axis x1y2, \
'tmp/cpy-over-time.csv' using 1:5 with lines linestyle 4 title "(re|m|c)alloc total count" axis x1y2, \
'tmp/cpy-over-time.csv' using 1:2 with lines linestyle 1 title "(mem|str|strn)cpy density", \
 'tmp/cpy-over-time.csv' using 1:4 with lines linestyle 2 title "(re|m|c)alloc density",
