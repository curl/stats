# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "GitHub: open issues and pull requests" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of open issues and pull-requests"

set style line 1 \
    linecolor rgb '#40a0ad' \
    linetype 1 linewidth 1

set style line 2 \
    linecolor rgb '#f0605d' \
    dt 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror
unset mxtics
set ytics 10 nomirror

# limit the xrange simply because we didn't use github much before 2015
set yrange [0:]
set xrange ["2015-03-01":]

if (!exists("logo")) logo="stats/curl-symbol-light.png"
set pixmap 1 logo
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/gh-open.csv' using 1:2 with lines linestyle 1 title "Open that day", \
 'tmp/gh-open.csv' using 1:3 with lines linestyle 2 title "90 day average"
