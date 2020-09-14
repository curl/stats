# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Contributors credited in the RELEASE NOTES" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of humans who contributed to the release"

set style line 1 \
    linecolor rgb '#00608d' \
    linetype 1 linewidth 4

set style line 2 \
    linecolor rgb '#808080' \
    dt 1 linewidth 1

set grid

set yrange [0:]
set xrange ["2005-01-01":]

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

#set xtics rotate
set xrange ["2005-01-01":]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

plot  'tmp/contributors-per-release.csv' using 1:3 with lines linestyle 1 title "median over 7 releases ", \
 'tmp/contributors-per-release.csv' using 1:2 with lines linestyle 2 title "Per release"
