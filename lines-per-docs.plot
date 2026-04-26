# SVG output
load "stats/terminal.include"

# title
set title "Lines of docs per KLOC" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "lines of documentation / KLOC"

set style line 1 \
    linecolor rgb '#a060ad' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror
set yrange [0:]
set ytics nomirror
unset mxtics

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/lines-per-docs.csv' using 1:2 with lines linestyle 1 title ""
