# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Public symbols exposed in headers" font ",48"
# where's the legend
set key bottom right

# Identify the axes
#set xlabel "Time"
set ylabel "Number of symbols listed"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set ytics nomirror

set yrange [0:]
set xrange ["2009-03-01":]

if (!exists("logo")) logo="stats/curl-symbol-light.png"
set pixmap 1 logo
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/symbols-over-time.csv' using 1:2 with lines linestyle 1 title ""
