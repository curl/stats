# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "curl vulnerabilities: C vs non-C mistakes\n{/*0.4per date of first version shipped with the flaw}" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of vulnerabilities"
set grid
unset border

set y2label "Lines of code" tc "#800080"
set y2tics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set format y2 "%.0s%c"
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set ytics nomirror

set style line 1 \
    linecolor rgb '#FF4040' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .5

set style line 2 \
    linecolor rgb '#800080' \
    linetype 2 dt "." linewidth 3

set style line 3 \
    linecolor rgb '#40C040' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .5

set style line 4 \
    linecolor rgb '#40C0FF' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .5

set style line 5 \
    linecolor rgb '#c0c040' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .5

set datafile separator ";"
plot \
 'tmp/c-vuln-over-time.csv' using 1:4 with linespoints linestyle 3 title "All vulnerabilities not C mistakes", \
 'tmp/c-vuln-over-time.csv' using 1:3 with linespoints linestyle 1 title "All C mistake vulnerabilities", \
 'tmp/c-vuln-over-time.csv' using 1:6 with linespoints linestyle 5 title "high/critical vulnerabilities not C mistakes", \
 'tmp/c-vuln-over-time.csv' using 1:5 with linespoints linestyle 4 title "high/critical C mistake vulnerabilities", \
 'tmp/lines-over-time.csv' using 1:2 axis x1y2 with lines linestyle 2 title "Lines of code"
