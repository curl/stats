# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "GitHub: issue life time until fixed\n{/*0.6For issues closed via a git commit message keyword}" font ",48"

# where's the legend
set key top right

# Identify the axes
set ylabel "Number of hours from creation on GitHub to fixed in git"

set style line 1 linecolor rgb '#40a0ad' linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror

#set mytics 10

# limit the xrange simply because we didn't use github much before 2015
set yrange [0:]
set xrange ["2015-10-01":]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/gh-fixes.csv' using 1:2 with lines linestyle 1 title "12 month median"
