# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Lines of code (incl comments)" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of lines of code excluding blank lines"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 3

set style line 2 \
    linecolor rgb '#00c0ad' \
    linetype 1 linewidth 3

set style line 3 \
    linecolor rgb '#ff404d' \
    linetype 1 linewidth 3

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

load "stats/config.plot"



# set the format of the dates on the x axis
set format x "%Y"
set format y "%.0s%c"

set xtics rotate 3600*24*365.25 nomirror out
set ytics nomirror
unset mxtics
set datafile separator ";"
plot 'tmp/lines-over-time.csv' using 1:2 with lines linestyle 1 title "all product code", \
 'tmp/lines-over-time.csv' using 1:3 with lines linestyle 2 title "libcurl", \
 'tmp/lines-over-time.csv' using 1:4 with lines linestyle 3 title "curl tool"
