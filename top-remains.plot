# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Top-40 authors with production code remaining in master" font ",48"
# where's the legend
set key top center

# Identify the axes
set ylabel "Number of lines of code"

# for the boxes
set boxwidth 0.9 relative
set style fill solid

set grid
unset border

unset xtics
set ytics out
set yrange [0:]

# set the format of the dates on the x axis
set datafile separator ";"

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

plot 'tmp/top-remains.csv' using 1:3 with boxes fc "#a0a0e0" title "", \
'tmp/top-remains.csv' using 1:0:2 with labels title "" offset 0,1 font ", 24" rotate left tc lt 1
