# SVG output
set terminal svg size 1920,1080 dynamic font ",20"

# title
set title "Commit time zone distribution since 2010" font ",48"
# where's the legend
set key top center

# Identify the axes
set ylabel "Used in commits this many times"

# for the boxes
set boxwidth 0.6 relative
set style fill solid 0.9

set grid
unset border

unset xtics
set ytics out
set yrange [0:]

# set the format of the dates on the x axis
set datafile separator ";"

set pixmap 1 "stats/map-time-zone.png"
set pixmap 1 at screen 0.06, 0.0 width screen 0.89 behind

set pixmap 2 "stats/curl-symbol-light.png"
set pixmap 2 at screen 0.35, 0.30 width screen 0.30 behind

plot 'tmp/timezones.csv' using 1:3 with boxes fc "#602020" title ""
# 'tmp/top-cwe.csv' using 1:-1:2 with labels title "" offset 0,1 font ", 24" rotate left tc lt 0
