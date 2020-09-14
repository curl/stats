# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Daniel's share of commits" font ",48"
# where's the legend
set key top right

# Identify the axes
#set xlabel "Time"
set ylabel "Percentage of git commits"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 5
set style line 2 \
    linecolor rgb '#40c040' \
    linetype 1 linewidth 5
set style line 3 \
    linecolor rgb '#a0a0a0' \
    linetype 3 linewidth 1

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set ytics 10

set yrange [0:]
set xrange ["1999-10-01":]

set boxwidth 0.2 relative
set style fill solid

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25

set datafile separator ";"
plot  'tmp/daniel-vs-rest.csv' using 1:4 with boxes linestyle 3 title "Daniel's monthly share", \
'tmp/daniel-vs-rest.csv' using 1:2 with lines linestyle 1 title "Daniel Stenberg accumulated", \
 'tmp/daniel-vs-rest.csv' using 1:3 with lines linestyle 2 title "Everyone else accumulated"
 