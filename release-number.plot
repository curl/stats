# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "curl releases" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of curl releases"

set style line 1 \
    linecolor rgb '#c0303d' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize 0.4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
set ytics 25 nomirror
unset mxtics

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/release-number.csv' using 1:3 with points linestyle 1 title "", \
 'tmp/release-number.csv' using 1:3:2 every 5 with labels left offset 0.2,-0.2 font ",18" rotate by -45 tc "#00c000" title ""
