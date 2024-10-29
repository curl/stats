# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Vulnerability severity since 2010\n{/*0.4per report date}" font ",48"
# where's the legend
set key top center

# Identify the axes
set ylabel "Number of reports / % of reports"
set grid
unset border

#set y2label "Share of reports high or critical" tc "#FF4040"
#set y2tics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.15, 0.25 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
set ytics nomirror

set xrange ["2010-01-01":]
set y2range [0:]

set datafile separator ";"

set style line 1 \
    linecolor rgb '#40c040' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .5

set style line 2 \
    linecolor rgb '#c0c040' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .5

set style line 3 \
    linecolor rgb '#4040FF' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .5

set style line 4 \
    linecolor rgb '#FF4040' \
    linetype 1 linewidth 2 \
    pointtype 7 pointsize .5

plot \
 'tmp/high-vuln-reports.csv' using 1:3 with linespoints linestyle 1 title "Low", \
 'tmp/high-vuln-reports.csv' using 1:4 with linespoints linestyle 2 title "Medium", \
 'tmp/high-vuln-reports.csv' using 1:5 with linespoints linestyle 3 title "High", \
 'tmp/high-vuln-reports.csv' using 1:6 with linespoints linestyle 4 title "Critical", \
 'tmp/high-vuln-reports.csv' using 1:7 with lines lc "#000000" lw 4 title "% share High or Critical"
