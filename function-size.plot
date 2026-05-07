# SVG output
load "stats/terminal.include"

# title
set title "Median and average function size\n{/*0.4including comments and blank lines}" font ",48"
set key top center

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set style line 2 \
    linecolor rgb '#008000' \
    linetype 1 linewidth 4

set style line 3 \
    linecolor rgb '#800000' \
    linetype 1 linewidth 2

set grid
unset border

set yrange [0:]
set y2range [0:]
set ylabel "Number of functions" tc "#800000"
set y2label "Function length (lines)"
set y2tics

# time formatted using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate
set ytics nomirror
unset mxtics

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/function-size.csv' using 1:4 with lines linestyle 3 title "Number of functions", \
  ARG1.'/function-size.csv' using 1:2 axis x1y2 with lines linestyle 1 title "Median length", \
  ARG1.'/function-size.csv' using 1:3 axis x1y2 with lines linestyle 2 title "Average length"
