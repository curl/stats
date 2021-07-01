# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Comment share in source code" font ",48"
# where's the legend
set key bottom right

# Identify the axes
#set xlabel "Time"
set ylabel "Percent of lines that are comments"

#set y2label "Number of lines"
#set y2tics 25000
set ytics nomirror
set xtics rotate 3600*24*365.25 nomirror

set style line 1 \
    linecolor rgb '#00a06d' \
    linewidth 4
set style line 2 \
    linecolor rgb '#a0006d' \
    linewidth 2
set style line 3 \
    linecolor rgb '#00a0ad' \
    linewidth 2
set style line 4 \
    linecolor rgb '#a0a06d' \
    linewidth 2

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

#set yrange [0:]
#set xrange ["2009-03-01":]
set y2range [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/comments.csv' using 2:7 with lines linestyle 1 title ""
# 'tmp/comments.csv' using 2:5 with lines linestyle 2 title "Lines with code" axis x1y2, \
# 'tmp/comments.csv' using 2:4 with lines linestyle 3 title "Commented lines" axis x1y2, \
#  'tmp/comments.csv' using 2:3 with lines linestyle 4 title "Empty lines" axis x1y2, \