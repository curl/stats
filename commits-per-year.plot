# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Commits per year" font ",48"
# where's the legend
set key top right

# Identify the axes
set xlabel "Years"
set ylabel "Commits"

# for the boxes
set boxwidth 0.8 relative
set style fill solid

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

# plot the flaw periods and the project age with titles and line width 3
plot 'tmp/commits-per-year.csv' using 1:2 with boxes title ""

