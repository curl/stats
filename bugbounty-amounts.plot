# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Bug bounty rewards" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "USD"
set grid
set ytics nomirror
unset xtics
unset border

set bmargin 4.0

# for the boxes
set boxwidth 0.8
set style fill solid

set style line 1 \
    linecolor rgb '#ff8040' \
    linetype 1 linewidth 4

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

set datafile separator ";"
plot 'tmp/bugbounty-amounts.csv' using 1:4 with boxes title 'Individual reward' lc "#80c040", \
 'tmp/bugbounty-amounts.csv' using 1:5 with lines title '5-reward average' linestyle 1, \
 'tmp/bugbounty-amounts.csv' using 1:0:2 with labels offset 0.1,-2.1 font ", 8" rotate by 90 title ''
