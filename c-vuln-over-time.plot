# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Vulnerabilities and C mistakes\n{/*0.4per date of first version shipped with the flaw}" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of vulnerabilities"
set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
set ytics 10

set style line 1 \
    linecolor rgb '#FF4040' \
    linetype 2 linewidth 3

set style line 2 \
    linecolor rgb '#800080' \
    linetype 2 linewidth 3

set datafile separator ";"
plot 'tmp/c-vuln-over-time.csv' using 1:3 with steps linestyle 1 title "Vulnerabilities due to C mistakes", \
 'tmp/c-vuln-over-time.csv' using 1:2 with steps linestyle 2 title "All vulnerabilities"
