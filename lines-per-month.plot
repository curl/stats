# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Lines of code added per month" font ",48"
# where's the legend
set key bottom left

# Identify the axes
#set xlabel "Time"
set ylabel "Delta number of lines of code"

set style line 1 \
    linecolor rgb '#c0c0ff' \
    linetype 1 linewidth 2

set style line 2 \
    linecolor rgb '#ff60ad' \
    dt 1 linewidth 4

set style line 3 \
    linecolor rgb '#40a040' \
    dt 1 linewidth 3

# for the boxes
set boxwidth 0.2 relative
set style fill solid

set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# better start at 2001 to make the initial import less impactful
set xrange ["2010-01-01":]

set y2label "% share of total LOC" tc "#40a040"
set y2tics

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

plot 'tmp/lines-per-month.csv' using 1:4 with lines linestyle 3 title "Share per total LOC count" axis x1y2, \
'tmp/lines-per-month.csv' using 1:3 with lines linestyle 2 title "12 month average", \
'tmp/lines-per-month.csv' using 1:2 with lines linestyle 1 title "Lines this month"

