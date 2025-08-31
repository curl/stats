# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Lines in curl.1 man page per command line option" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Lines per available command line option"

set style line 1 \
    linecolor rgb '#00c04d' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror
set ytics nomirror
unset mxtics

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set format y "%.0s%c"
set datafile separator ";"
plot 'tmp/manpage-lines-per-option.csv' using 1:2 with lines linestyle 1 title ""
