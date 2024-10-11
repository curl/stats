# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "commit count per committer" font ",48"
# where's the legend
set key top left

# Identify the axes
set xlabel "Number of commit authors (log scale)"
set ylabel "Number of commits (log scale)"
set ytics 2 nomirror
set xtics 2 nomirror out
set logscale y 2
set logscale x 2

set style line 1 \
    linecolor rgb '#008000' \
    linetype 1 linewidth 3

set grid
unset border

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

set datafile separator ";"

plot 'tmp/contrib-tail.csv' using 3:2 with lines linestyle 1 title ""
