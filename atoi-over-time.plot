# SVG output
load "stats/terminal.include"

# title
set title "atoi function call density" font ",48"
# where's the legend
set key top center

# Identify the axes
set ylabel "Functions calls per KLOC (excl comments)"
set y2label "Total function count"
set y2tics

set style line 1 \
    linecolor rgb '#c060ad' \
    linetype 1 linewidth 3

set style line 2 \
    linecolor rgb '#ff404d' \
    linetype 1 dt "_" linewidth 1

set ytics nomirro

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set yrange [0:]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set datafile separator ";"
plot ARG1.'/atoi-over-time.csv' using 1:2 with lines linestyle 2 title "(atoi|strtol|strtoul|strtoll) total count" axis x1y2, \
ARG1.'/atoi-per-kloc.csv' using 1:2 with lines linestyle 1 title "call density"
