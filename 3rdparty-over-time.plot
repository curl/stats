# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Third party libraries" font ",48"
# where's the legend
set key top left

# Identify the yaxes
set ylabel "Number of supported third party libraries"

set style line 1 \
    linecolor rgb '#80ff00' \
    linetype 1 linewidth 4 \
    pointtype 7

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set ytics 2
set xtics rotate 3600*24*365.25 nomirror

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/3rdparty-over-time.csv' using 1:3 with points linestyle 1 title "", \
 'tmp/3rdparty-over-time.csv' using 1:3:2 with labels font ",16" rotate by -35 tc "#0000ff" title ""
