# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "curl commit distribution" font ",48"
# where's the legend
set key top left

# Identify the axes
set xlabel "Number of committers"
set ylabel "Number of commits"
set ytics nomirror
set xtics nomirror out

set style line 1 \
    linecolor rgb '#c080ff' \
    linetype 1 linewidth 2

set grid
unset border

set datafile separator ";"

plot 'tmp/contrib-tail.csv' using 3:2 with boxes linestyle 1 title ""
