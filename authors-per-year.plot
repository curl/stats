# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Number of authors per year" font ",48"
# where's the legend
set key top left

# Identify the axes
set xlabel "Years"
set ylabel "Number of humans"

# for the boxes
set boxwidth 0.8 relative
set style fill solid 0.5

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

# start Y at 0
set yrange [0:]

# the dates need to be manipulated as strings - you can't do numerical arithmetic on them.
# / Lee Philips

dayoffset = '30'
set xrange ["2009-06-".dayoffset:]

plot 'tmp/authors-per-year.csv' using 1:2 with boxes title "All authors" fc 'green', 'tmp/authors-per-year.csv' using (strcol(1)[1:8].dayoffset):3 with boxes title "First-time authors"
