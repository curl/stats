# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Number of files in version control" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of files"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 1 linewidth 4

set style line 2 \
    linecolor rgb '#008000' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate
set ytics nomirror
unset mxtics

if (!exists("logo")) logo="stats/curl-symbol-light.png"
set pixmap 1 logo
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/files-over-time.csv' using 1:2 with lines linestyle 1 title "All files", \
  'tmp/files-over-time.csv' using 1:3 with lines linestyle 2 title "Non-test files"
