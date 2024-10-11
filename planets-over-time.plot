# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Number of planets running curl" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of planets"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 7 linewidth 4 \
    pointtype 6

set grid
set yrange [0:]
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set ytics 1
set xtics 3600*24*365.25 nomirror rotate

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/planets-over-time.csv' using 1:3 with steps linestyle 1 title "", \
'tmp/planets-over-time.csv' using 1:3:2 with labels offset 0,1 font ",38" tc "#ff0000" title "", \
'tmp/planets-over-time.csv' using 1:3 with points pt 6 title ""
