# SVG output
set terminal svg size 1920,1080 dynamic font ",24"
set title "Project age" font ",48"
set key top left
set ylabel "Days since"

set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 4
set style line 2 linecolor rgb '#af6000' linetype 1 linewidth 4
set style line 3 linecolor rgb '#40c040' linetype 1 linewidth 4
set grid
unset border
set xtics rotate 3600*24*365.26 nomirror out
unset mxtics
set ytics 1000 nomirror

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set yrange [0:]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

set format x "%Y"
set format y "%.0s%c"
set datafile separator ";"
plot 'tmp/project-age.csv' using 1:2 with lines linestyle 1 title "httpget 0.1", \
 'tmp/project-age.csv' using 1:3 with lines linestyle 2 title "curl 4.0", \
 'tmp/project-age.csv' using 1:4 with lines linestyle 3 title "libcurl 7.1"
