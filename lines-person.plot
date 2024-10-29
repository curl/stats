# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Added and removed lines in entire repo" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of lines"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 4
set style line 2 \
    linecolor rgb '#40c040' \
    linewidth 4
set style line 3 \
    linecolor rgb '#ffa040' \
    linewidth 2
set style line 4 \
    linecolor rgb '#8040ff' \
    linewidth 2
set style line 5 \
    linecolor rgb '#808080' \
    linewidth 3

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics nomirror rotate 3600*24*365.25
set ytics nomirror
unset mxtics

set yrange [0:]
set xrange ["1999-12-01":]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/lines-person.csv' using 1:2 with lines linestyle 1 title "Lines added by Daniel", \
 'tmp/lines-person.csv' using 1:3 with lines linestyle 2 title "Lines added by others", \
 'tmp/lines-person.csv' using 1:4 with lines linestyle 3 title "Lines removed by Daniel", \
 'tmp/lines-person.csv' using 1:5 with lines linestyle 4 title "Lines removed by others", \
 'tmp/lines-person.csv' using 1:6 with lines linestyle 5 title "Total number of lines present"
