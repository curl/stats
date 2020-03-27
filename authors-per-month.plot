# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Authors per month" font ",48"
# where's the legend
set key top left

# Identify the axes
set xlabel "Time"
set ylabel "Authors"

# for the boxes
set boxwidth 0.7 relative
set style fill solid

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics out nomirror

set xrange ["2010-01-01":]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/authors-per-month.csv' using 1:3 with boxes title "Authors"
