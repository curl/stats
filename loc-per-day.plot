# SVG output
load "stats/terminal.include"
set title "Lines of code growth" font ",48"
set key top left
set ylabel "Lines of code per day of existence"

set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 4
set grid
unset border
set xtics rotate 3600*24*365.26 nomirror
unset mxtics
set ytics nomirror

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]
set xrange ["1996-12-20":]

load "stats/logo.include"

set format x "%Y"
set datafile separator ";"
plot ARG1.'/loc-per-day.csv' using 1:2 with lines linestyle 1 title ""