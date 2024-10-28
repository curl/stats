# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "GitHub: issue life time until fixed\n{/*0.8 for issues closed via a git commit message keyword}" font ",48"

# where's the legend
set key top right

# Identify the axes
set ylabel "Number of hours from creation on GitHub to fixed in git"

set style line 1 \
    linecolor rgb '#40a0ad' \
    linetype 1 linewidth 1

set style line 2 \
    linecolor rgb '#f0605d' \
    dt 1 linewidth 4

set style line 3 \
    linecolor rgb '#60f05d' \
    dt 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d %H:%M:%S"
set xdata time
set xtics 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror

#set mytics 10

# limit the xrange simply because we didn't use github much before 2015
set yrange [0:]
set xrange ["2015-10-01":]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/gh-fixes.csv' using 2:4 with lines linestyle 2 title "12 month median"#,\
# 'tmp/gh-fixes.csv' using 2:5 with lines linestyle 3 title "12 month average"

# plot 'tmp/gh-fixes.csv' using 2:3 with lines linestyle 1 title "Issue lifetime", \
