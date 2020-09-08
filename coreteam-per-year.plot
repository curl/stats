# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Size of the core team per year, number of persons with 10 commits or more" font ",48"
# where's the legend
set key top left

# Identify the axes
set xlabel "Years"
set ylabel "Number of humans"

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

plot 'tmp/coreteam-per-year.csv' using 1:2 with boxes title "Core team size"
