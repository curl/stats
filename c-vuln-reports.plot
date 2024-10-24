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

set y2label "Number of vulnerabilities" tc "#800080"
set y2tics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set ytics 10 nomirror

set yrange [0:]
set xrange ["2010-01-01":]

set style line 1 \
    linecolor rgb '#FF4040' \
    linetype 2 linewidth 3

set style line 2 \
    linecolor rgb '#800080' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .3

set style line 3 \
    linecolor rgb '#404040' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .3

set style line 4 \
    linecolor rgb '#4040e0' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .3

set datafile separator ";"
plot 'tmp/c-vuln-reports.csv' using 1:2 axis x1y2 with linespoints linestyle 2 title "Number of vulnerabilities", \
 'tmp/c-vuln-reports.csv' using 1:3 axis x1y2 with linespoints linestyle 3 title "C mistakes", \
 'tmp/c-vuln-reports.csv' using 1:4 axis x1y2 with linespoints linestyle 4 title "Not C mistakes", \
 'tmp/c-vuln-reports.csv' using 1:5 with lines linestyle 1 title "C mistake share"
