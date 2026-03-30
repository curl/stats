# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Project days per new command line option" font ",48"
# where's the legend
set key top center

# Identify the axes
set ylabel "Project age in days / command line options"

set style line 1 \
    linecolor rgb '#c060ad' \
    linetype 1 linewidth 3

set ytics nomirror

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set yrange [0:]
set xrange ["1998-03-20":]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set datafile separator ";"
plot ARG1.'/days-per-cmdline-option.csv' using 1:2 with lines linestyle 1 title ""
