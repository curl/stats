# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "curl sponsors at Open Collective" font ",48"
# where's the legend
set key top left

# Identify the axes
set xlabel "Number of sponsors"
set ylabel "Sponsored amout (USD)"
set ytics nomirror
set xtics nomirror out

set style line 1 \
    linecolor rgb '#FF00ff' \
    linetype 1 linewidth 4

set grid
unset border

set datafile separator ";"

plot 'tmp/donors.csv' using 2:3 with lines linestyle 1 title ""
