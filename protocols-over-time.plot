# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Supported transfer protocols" font ",48"
# where's the legend
set key top left

# Identify the axes
set xlabel "Time"
set ylabel "Number of protocols"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4 \
    pointtype 6

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/protocols-over-time.csv' using 1:3 with lines linestyle 1 title "Protocols", 'tmp/protocols-over-time.csv' using 1:3:2 with labels font ",18" tc "#ff0000" rotate by -22 title ""
