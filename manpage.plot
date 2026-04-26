# SVG output
load "stats/terminal.include"

# title
set title "Number of lines in the curl.1 man page" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of lines"

set style line 1 \
    linecolor rgb '#e06020' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate out
set ytics nomirror
unset mxtics

set yrange [0:]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/manpage.csv' using 2:3 with lines linestyle 1 title ""
