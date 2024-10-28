# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "GitHub: created issues + pull-requests" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of created issues and pull-requests"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 1

set style line 2 \
    linecolor rgb '#40a03d' \
    dt 1 linewidth 1

set style line 3 \
    linecolor rgb '#c0a03d' \
    dt 1 linewidth 4

set style line 4 \
    linecolor rgb '#80a0c0' \
    dt 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# limit the xrange simply because we didn't use github much before 2015
set yrange [0:]
set xrange ["2014-11-30":]
set xtics 3600*24*365.25 nomirror out
set ytics nomirror
unset mxtics

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/gh-monthly.csv' using 1:3 with lines linestyle 1 title "Monthly pull requests", \
 'tmp/gh-monthly.csv' using 1:4 with lines linestyle 2 title "Monthly issues", \
 'tmp/gh-monthly.csv' using 1:5 with lines linestyle 3 title "12 month average monthly PRs", \
 'tmp/gh-monthly.csv' using 1:6 with lines linestyle 4 title "12 month average monthly issues"