# SVG output
load "stats/terminal.include"

set title "Number of installs globally" font ",48"
set key top left

set ylabel "Number of installations"

set style line 1 linecolor rgb '#40c0ad' linetype 1 linewidth 5

set grid
unset border

set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set ytics nomirror

load "stats/logo.include"

set format x "%Y"
set format y "%.0s%c"
set datafile separator ";"
plot ARG1.'/install-history.csv' using 1:2 smooth bezier with lines linestyle 1 title ""
