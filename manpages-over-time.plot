# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Man pages" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of man pages"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate out
set ytics nomirror
unset mxtics

set yrange [0:]

if (!exists("logo")) logo="stats/curl-symbol-light.png"
set pixmap 1 logo
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/manpages-over-time.csv' using 2:3 with lines linestyle 1 title ""
