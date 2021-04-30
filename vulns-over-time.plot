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

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
set ytics 10

set style line 1 \
    linecolor rgb '#00a06d' \
    linetype 2 linewidth 2

set style line 2 \
    linecolor rgb '#f060ad' \
    linetype 2 linewidth 2

set datafile separator ";"
plot 'tmp/vulns-over-time.csv' using 2:3 with steps linestyle 1 title "Fixed in a release", \
 'tmp/cve-intro.csv' using 1:2 with steps linestyle 2 title "Vulnerability in release"
