# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Third party libraries" font ",48"
# where's the legend
set key top left

# Identify the yaxes
set ylabel "Number of supported third party libraries"

set style line 1 \
    linecolor rgb '#80c000' \
    linetype 1 linewidth 1 \
    pointtype 7 pointsize 0.4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set ytics 2
set xtics rotate 3600*24*365.25 nomirror
unset mxtics

load "stats/config.plot"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/3rdparty-over-time.csv' using 1:3 with linespoints linestyle 1 title "", \
 'tmp/3rdparty-over-time.csv' using 1:3:2 every 2::1 with labels right offset 0,.2 font ",18" rotate by -45 tc "#0000ff" title "", \
 'tmp/3rdparty-over-time.csv' using 1:3:2 every 2::0 with labels left offset 0.5,-.2 font ",18" rotate by -45 tc "#0000ff" title ""
