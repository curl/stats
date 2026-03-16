# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

set title "Commit size distribution\n{/*.5As a share of commits done over a rolling 365 day period}" font ",48"
set key bottom center horizontal out

set ylabel "Share of commits with different properties"

set style line 1  linecolor rgb '#0060ad' linewidth 2
set style line 2 linecolor rgb '#40c040' linewidth 2
set style line 3 linecolor rgb '#c0c040' linewidth 2
set style line 4 linecolor rgb '#f03030' linewidth 2
set style line 5 linecolor rgb '#f030f0' linewidth 2
set style line 6 linecolor rgb '#808080' linewidth 2

set grid
unset border

set timefmt "%Y-%m-%d"
set xdata time

set yrange [0:]

# cut off the first wild months after the sourceforge import
set xrange ["2000-04-01":]

set xtics rotate 3600*24*365.25 nomirror
set ytics 10 nomirror
unset mxtics

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/commit-sizes.csv' using 1:2 with lines linestyle 1 title "single file change", \
 ARG1.'/commit-sizes.csv' using 1:3 with lines linestyle 2 title "single line change", \
 ARG1.'/commit-sizes.csv' using 1:4 with lines linestyle 3 title "5+ files change", \
 ARG1.'/commit-sizes.csv' using 1:5 with lines linestyle 4 title "50+ new lines delta", \
 ARG1.'/commit-sizes.csv' using 1:6 with lines linestyle 5 title "20+ lines change", \
 ARG1.'/commit-sizes.csv' using 1:7 with lines linestyle 6 title "50+ lines change"
