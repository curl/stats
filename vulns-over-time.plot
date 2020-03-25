# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Vulnerabilities" font ",48"
# where's the legend
set key top left

# Identify the axes
set xlabel "Date of disclosure"
set ylabel "Number of vulnerabilities"
set grid

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"

set datafile separator ";"
plot 'tmp/vulns-over-time.csv' using 2:3 with lines title "Flaws" lw 3
