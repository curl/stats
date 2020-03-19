# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Number of commits per month"
# where's the legend
set key top left

# Identify the axes
set xlabel "Time"
set ylabel "Commits"

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

# plot the flaw periods and the project age with titles and line width 3
plot 'tmp/commits-per-month.csv' using 1:2 with lines title "Commits per month"

