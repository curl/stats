# SVG output
load "stats/terminal.include"

# title
set title "C vulnerability share\n{/*0.4per report date}" font ",48"
# where's the legend
set key bottom right

# Identify the axes
set ylabel "C mistake share %"
set grid
unset border

set y2label "Number of vulnerabilities" tc "#800080"
set y2tics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set ytics 10 nomirror

set yrange [0:]
set xrange ["2015-01-01":]

set style line 1 \
    linecolor rgb '#FF4040' \
    linetype 2 linewidth 5 dt "..."

set style line 3 \
    linecolor rgb '#40a040' \
    linetype 1 linewidth 3 \
    pointtype 7 pointsize .3

set style line 4 \
    linecolor rgb '#4040e0' \
    linetype 1 linewidth 3 \
    pointtype 7 pointsize .3

set datafile separator ";"
plot ARG1.'/c-vuln-reports.csv' using 1:3 axis x1y2 with lines linestyle 3 title "C mistake vulnerabilities", \
 ARG1.'/c-vuln-reports.csv' using 1:4 axis x1y2 with lines linestyle 4 title "Not C mistake vulnerabilities", \
 ARG1.'/c-vuln-reports.csv' using 1:5 with lines linestyle 1 title "C mistake share"
