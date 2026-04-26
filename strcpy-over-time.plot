# SVG output
load "stats/terminal.include"

set title "strcpy density" font ",48"
set key bottom center

set ylabel "strcpy functions calls in src and lib per KLOC (excl comments)"
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

set timefmt "%Y-%m-%d"
set xdata time
set yrange [0:]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set datafile separator ";"
plot ARG1.'/strcpy-over-time.csv' using 1:3 with lines linestyle 3 title "strcpy total count" axis x1y2, \
ARG1.'/strcpy-over-time.csv' using 1:2 with lines linestyle 1 title "strcpy density"
