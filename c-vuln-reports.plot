# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "curl C vulnerability share since 2010\n{/*0.4per report date}" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "C mistake share %"
set grid
unset border

set y2label "Total number of vulnerabilities" tc "#800080"
set y2tics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
set ytics 10

set xrange ["2010-01-01":]

set style line 1 \
    linecolor rgb '#FF4040' \
    linetype 2 linewidth 3

set style line 2 \
    linecolor rgb '#800080' \
    linetype 2 linewidth 3

set datafile separator ";"
plot \
 'tmp/c-vuln-reports.csv' using 1:5 with lines linestyle 1 title "C mistake share", \
 'tmp/c-vuln-reports.csv' using 1:2 axis x1y2 with lines linestyle 2 title "Total number of reported vulnerabilities"
