# SVG output
load "stats/terminal.include"

# title
set title "releases" font ",48"
unset key

# Identify the axes
set ylabel "Number of releases"

set style line 1 \
    linecolor rgb '#c0303d' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize 0.4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate time 1 years nomirror out
set ytics nomirror
unset mxtics

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/release-number.csv' using 1:3 with points linestyle 1 title "", \
 ARG1.'/release-number.csv' using 1:3:2 every 5 with labels left offset 0.2,-0.2 font ",18" rotate by -45 tc "#008000"
