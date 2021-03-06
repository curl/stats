# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Share of CVEs due to C mistakes" font ",48"
# where's the legend
set key bottom left

# Identify the axes
set xlabel "Date of disclosure"
set ylabel "Share of the vulnerabilities due to C mistakes"
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
    linecolor rgb '#0060ad' \
    linetype 2 linewidth 3

set style line 2 \
    linecolor rgb '#ff60ad' \
    linetype 2 linewidth 2

set datafile separator ";"
plot 'tmp/c-vuln-over-time.csv' using 1:2 with steps linestyle 1 title "Accumulated over all time", \
 'tmp/c-vuln-over-time.csv' using 1:3 with lines linestyle 2 title "Last 12 month period"
