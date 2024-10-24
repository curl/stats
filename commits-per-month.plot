# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Commits per month" font ",48"
# where's the legend
set key top center

# Identify the axes
#set xlabel "Time"
set ylabel "Commits"

set style line 1 \
    linecolor rgb '#c0c0ff' \
    linetype 1 linewidth 2

set style line 2 \
    linecolor rgb '#ff60ad' \
    dt 1 linewidth 3

set style line 3 \
    linecolor rgb '#3080ff' \
    dt 1 linewidth 3

# for the boxes
set boxwidth 0.6 relative
set style fill solid

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set ytics nomirror
set xtics 3600*24*365.25 nomirror rotate out
unset mxtics

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

plot 'tmp/commits-per-month.csv' using 1:2 with boxes fc "#80c080" title "Monthly commits", \
 'tmp/commits-per-month.csv' using 1:4 with lines linestyle 3 title "All-time average", \
 'tmp/commits-per-month.csv' using 1:3 with lines linestyle 2 title "12 month average"
