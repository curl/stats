# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Lines of code (incl comments)" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of lines of code excluding blank lines"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set style line 2 \
    linecolor rgb '#00c0ad' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25
set datafile separator ";"
plot 'tmp/lines-over-time.csv' using 1:2 with lines linestyle 1 title "lib + src + include", \
 'tmp/lines-over-time.csv' using 1:3 with lines linestyle 2 title "lib only"
