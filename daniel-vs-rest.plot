# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Daniel Stenberg's share of authored commits" font ",48"
# where's the legend
set key top right horizontal

# Identify the axes
#set xlabel "Time"
set ylabel "Percentage"

set style line 1 \
    linecolor rgb '#40c040' \
    linetype 1 linewidth 5
set style line 2 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 2
set style line 3 \
    linecolor rgb '#a0a0a0' \
    linetype 3 linewidth 1
set style line 4 \
    linecolor rgb '#c04040' \
    linetype 3 linewidth 2

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set ytics 10 nomirror

set yrange [0:]
set xrange ["1999-10-01":]

set boxwidth 0.5 relative
set style fill solid

if (!exists("logo")) logo="stats/curl-symbol-light.png"
set pixmap 1 logo
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 out nomirror
unset mxtics

set datafile separator ";"
plot  'tmp/daniel-vs-rest.csv' using 1:4 with boxes linestyle 3 title "Monthly share of commit count", \
'tmp/daniel-vs-rest.csv' using 1:2 with lines linestyle 1 title "share of commit count", \
'tmp/daniel-vs-rest.csv' using 1:5 with lines linestyle 4 title "share of added lines", \
'tmp/daniel-vs-rest.csv' using 1:6 with lines linestyle 2 title "share of removed lines"
