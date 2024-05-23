# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Number of test cases per KLOC" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "number of tests / KLOC"

set style line 1 \
    linecolor rgb '#40c04d' \
    linetype 1 linewidth 4

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror
set yrange [0:]
set ytics 1

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/lines-per-test.csv' using 1:2 with lines linestyle 1 title ""
