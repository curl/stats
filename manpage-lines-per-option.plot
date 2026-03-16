# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Lines in curl.1 man page per command line option" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Lines per available command line option"

set style line 1 \
    linecolor rgb '#00c04d' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror
set ytics nomirror
unset mxtics

set yrange [0:]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set format y "%.0s%c"
set datafile separator ";"
plot ARG1.'/manpage-lines-per-option.csv' using 1:2 with lines linestyle 1 title ""
