# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Commits per month" font ",48"
# where's the legend
set key top right

# Identify the axes
set xlabel "Time"
set ylabel "Commits"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set style line 2 \
    linecolor rgb '#ff60ad' \
    dt 1 linewidth 4

# for the boxes
set boxwidth 0.2 relative
set style fill solid

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

#set xtics rotate

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

plot  'tmp/commits-per-month.csv' using 1:3 with lines linestyle 2 title "12 month average", \
'tmp/commits-per-month.csv' using 1:2 with lines linestyle 1 title "Commits"
