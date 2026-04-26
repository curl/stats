# SVG output
load "stats/terminal.include"

# title
set title "Commit author activity" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of different authors"

set style line 1  linecolor rgb '#0060ad' linewidth 1
set style line 2 linecolor rgb '#40c040' linewidth 1
set style line 3 linecolor rgb '#c0c040' linewidth 1
set style line 5 linecolor rgb '#f03030' linewidth 1

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]
set xrange ["2018-01-01":]

set xtics rotate 3600*24*365.25 nomirror
set ytics 10 nomirror
unset mxtics

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/authors-active.csv' using 1:2 with lines linestyle 1 title "Within 120 days", \
 ARG1.'/authors-active.csv' using 1:4 with lines linestyle 2 title "Within 60 days", \
 ARG1.'/authors-active.csv' using 1:5 with lines linestyle 5 title "Within 30 days", \
 ARG1.'/authors-active.csv' using 1:6 with lines linestyle 3 title "Within 7 days"
