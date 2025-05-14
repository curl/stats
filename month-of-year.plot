# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Commits per month" font ",48"
# where's the legend
set key top center

# Identify the axes
#set xlabel "Time"
set ylabel "Commits done this month"

# for the boxes
set boxwidth 0.9 relative
set style fill solid

set grid
unset border

unset xtics
set ytics out nomirror
set yrange [0:]

# set the format of the dates on the x axis
set datafile separator ";"

load "stats/config.plot"

plot 'tmp/month-of-year.csv' using 1:3 with boxes fc "#606000" title "", \
 'tmp/month-of-year.csv' using 1:3:2 with labels title "" offset 0,-1 font ", 36" rotate right tc lt 5
