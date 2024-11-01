# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Vulnerabilities in recent releases" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of vulnerabilities"

set style line 1 \
    linecolor rgb '#c0c0ff' \
    linetype 1 linewidth 2

set style line 2 \
    linecolor rgb '#80a040' \
    dt 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate
unset mxtics
set ytics 5

set boxwidth 0.8 relative
set style fill solid

set xrange ["2020-01-01":]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set xtics out
set datafile separator ";"
set key autotitle col
plot 'tmp/vulns-releases.csv' using 1:3 with points pt 7 ps 0.6 title "",\
  'tmp/vulns-releases.csv' using 1:3:2 with labels left offset .2,.2 font ", 16" rotate by 60 title ""
