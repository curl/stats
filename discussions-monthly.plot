# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "GitHub: discussion threads and comments" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of discussion threads and comments"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 1

set style line 2 \
    linecolor rgb '#40a03d' \
    dt 1 linewidth 1

set style line 3 \
    linecolor rgb '#c0a03d' \
    dt 1 linewidth 4

set style line 4 \
    linecolor rgb '#80a0c0' \
    dt 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# https://github.com/openssl/openssl/discussions/21377
set yrange [0:]
set xrange ["2023-07-01":"2025-04-30"]
set xtics 3600*24*365.25 nomirror out
set ytics nomirror
unset mxtics

load "stats/config.plot"



# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/discussions-monthly.csv' using 1:2 with lines linestyle 1 title "Monthly discussion threads", \
 'tmp/discussions-monthly.csv' using 1:3 with lines linestyle 3 title "12 month average monthly discussion threads", \
 'tmp/discussions-monthly.csv' using 1:4 with lines linestyle 2 title "Monthly discussion comments", \
 'tmp/discussions-monthly.csv' using 1:5 with lines linestyle 4 title "12 month average monthly discussion comments",