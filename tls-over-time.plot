# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "TLS backends" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of supported TLS backends"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4 \
    pointtype 6

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
#set yrange [0:16]
set ytics 2
set xtics rotate 3600*24*365.25 nomirror

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/tls-over-time.csv' using 1:3 with linespoints linestyle 1 title "", \
 'tmp/tls-over-time.csv' using 1:3:2 with labels offset -2,1 font ",22" rotate by -22 tc "#ff0000" title ""
