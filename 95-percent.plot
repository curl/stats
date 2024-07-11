# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Number of persons authoring 95% of the commits" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Years"
set ylabel "Number of authors"
unset border

# for the boxes
set boxwidth 0.9 relative
set style fill solid

set grid ytics
set ytics nomirror

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror in
unset mxtics

set xrange ["1999-06-01":]
set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

plot 'tmp/95-percent.csv' using 1:2 with boxes title "", \
  'tmp/95-percent.csv' using 1:3 with lines title "5-year average" lw 4, \
  'tmp/95-percent.csv' using 1:4 with lines title "All-time average" lw 4
