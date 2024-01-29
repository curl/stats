# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Test cases" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of tests"

set y2label "Lines of code" tc "#40c040"
set y2tics

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set style line 2 \
    linecolor rgb '#40c040' \
    linetype 2 linewidth 2

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate

set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/tests-over-time.csv' using 2:3 with lines linestyle 1 title "Test cases", \
 'tmp/lines-over-time.csv' using 1:2 axis x1y2 with lines linestyle 2 title "Lines of code"
