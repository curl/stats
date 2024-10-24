# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Fixed and created security vulnerabilities" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of vulnerabilities"
set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set ytics 10 nomirror

set style line 1 \
    linecolor rgb '#00a06d' \
    linetype 2 linewidth 2

set style line 2 \
    linecolor rgb '#f060ad' \
    linetype 2 linewidth 2

set datafile separator ";"
plot 'tmp/vulns-over-time.csv' using 2:3 with steps linestyle 1 title "Fixed in a release", \
 'tmp/cve-intro.csv' using 1:2 with steps linestyle 2 title "Vulnerability introduced"
