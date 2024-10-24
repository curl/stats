# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Authors with code left in product code\n{/*0.6 1K or more lines attributed to them by git blame -CCC}" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of authors"

set style line 4 \
    linecolor rgb '#408080' \
    linewidth 2
set style line 5 \
    linecolor rgb '#f03030' \
    linewidth 2

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xrange ["2010-01-01":]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set ytics nomirror
set datafile separator ";"
plot 'tmp/authorremains.csv' using 1:5 with lines linestyle 4 title "1,000 lines or more", \
 'tmp/authorremains.csv' using 1:6 with lines linestyle 5 title "10,000 lines or more"
