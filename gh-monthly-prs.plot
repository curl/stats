# SVG output
load "stats/terminal.include"

# title
set title "GitHub: created pull-requests" font ",48"
set key top left

set ylabel "Number of created pull-requests per month"

set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 1
set style line 3 linecolor rgb '#c0a03d' dt 1 linewidth 4

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
plot ARG1.'/gh-monthly.csv' using 1:3 with lines linestyle 1 title "Monthly pull requests", \
 ARG1.'/gh-monthly.csv' using 1:5 with lines linestyle 3 title "12 month average monthly PRs"
