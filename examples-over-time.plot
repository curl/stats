# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Stand-alone libcurl examples\n{/*0.4in the docs/examples subdirectory}" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of examples"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate
set ytics nomirror
unset mxtics

set yrange [0:]

load "stats/config.plot"



# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/examples-over-time.csv' using 2:3 with lines linestyle 1 title ""
