# SVG output
load "stats/terminal.include"

# title
set title "Bug bounty rewards" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "USD"
set xlabel "All reported vulnerabilities"
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

load "stats/logo.include"

set datafile separator ";"
plot ARG1.'/bugbounty-amounts.csv' using 1:4 with boxes title 'Individual reward' lc "#80c040", \
 ARG1.'/bugbounty-amounts.csv' using 1:5 with lines title '5-reward average' linestyle 1
