# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Commits per year" font ",48"
# where's the legend
set key top center

# Identify the axes
#set xlabel "Years"
set ylabel "Commits"

# for the boxes
set boxwidth 0.8 relative
set style fill solid

set grid ytics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
unset border
set ytics nomirror

set xrange ["1999-06-01":]
set yrange [0:]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

# plot the flaw periods and the project age with titles and line width 3
plot 'tmp/commits-per-year.csv' using 1:2 with boxes fc "#e07000" title "", \
 'tmp/commits-per-year.csv' using 1:2:2 with labels title "" offset 0,.5 font ", 20" tc lt 1, \
 'tmp/commits-per-year.csv' using 1:3 with lines lw 3 title "5 year average"
