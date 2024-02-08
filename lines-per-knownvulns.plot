# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Lines of code per known vulnerability\n{/*0.4later data is too early to be fair}" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "lines of code / number of known CVEs present"

set style line 1 \
    linecolor rgb '#4000ff' \
    linetype 1 linewidth 2

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror
set yrange [0:]
set xrange [:"2023-02-01"]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/lines-per-knownvulns.csv' using 1:2 with lines linestyle 1 title ""
