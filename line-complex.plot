# SVG output
load "stats/terminal.include"

# title
set title "Source code line complexity\n{/*0.4Average and median cyclomatic complexity per production source code line}" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Cyclomatic pmccabe complexity per source code line"

set style line 1 \
    linecolor rgb '#4040C0' \
    linewidth 4

set style line 2 \
    linecolor rgb '#C040C0' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
set ytics nomirror
unset mxtics

load "stats/logo.include"

set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/line-complex.csv' using 1:2 with lines linestyle 1 title "average", \
 ARG1.'/line-complex.csv' using 1:3 with lines linestyle 2 title "median"

