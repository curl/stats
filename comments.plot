# SVG output
load "stats/terminal.include"
set title "Source code comment share" font ",48"
set key bottom right

# Identify the axes
set ylabel "Percent of lines that are comments"

set ytics nomirror
set xtics rotate 3600*24*365.25 nomirror
unset mxtics

set style line 1 \
    linecolor rgb '#00a06d' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set yrange [0:]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/comments.csv' using 2:7 with lines linestyle 1 title ""
