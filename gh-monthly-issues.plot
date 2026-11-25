# SVG output
load "stats/terminal.include"

set title "GitHub: created issues per month" font ",48"
set key top left

set ylabel "Number of created issues"

set style line 2 linecolor rgb '#40a03d' dt 1 linewidth 1
set style line 4 linecolor rgb '#80a0c0' dt 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# limit the xrange simply because we didn't use github much before 2015
set yrange [0:]
set xrange ["2014-11-30":]
set xtics time 1 years nomirror out
set ytics nomirror
unset mxtics

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/gh-monthly.csv' using 1:4 with lines linestyle 2 title "Monthly issues", \
 ARG1.'/gh-monthly.csv' using 1:6 with lines linestyle 4 title "12 month average monthly issues"
