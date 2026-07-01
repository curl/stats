# SVG output
load "stats/terminal.include"

set title "Number of authors who did X% of all commits" font ",48"
set key top left

set ylabel "Number of authors"

set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 4
set style line 2 linecolor rgb '#c06000' linetype 1 linewidth 4
set style line 3 linecolor rgb '#008020' linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics time 1 years nomirror rotate out
unset mxtics
set ytics nomirror

set yrange [0:]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/authors-percent-90.csv' using 1:2 with steps linestyle 1 title "90 percent", \
 ARG1.'/authors-percent-80.csv' using 1:2 with steps linestyle 2 title "80 percent", \
 ARG1.'/authors-percent-70.csv' using 1:2 with steps linestyle 3 title "70 percent"

