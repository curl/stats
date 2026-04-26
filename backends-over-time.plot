# SVG output
load "stats/terminal.include"

# title
set title "backends" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of backends"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 2 linewidth 1 \
    pointtype 7 pointsize 0.5

set style line 2 \
    linecolor rgb '#808080' \
    linetype 1 linewidth 1 \
    pointtype 7 pointsize 0.5

set style line 3 \
    linecolor rgb '#c0c080' \
    linetype 1 linewidth 1 \
    pointtype 7 pointsize 0.5

set style line 4 \
    linecolor rgb '#c000c0' \
    linetype 1 linewidth 1 \
    pointtype 7 pointsize 0.5

set style line 5 \
    linecolor rgb '#c00040' \
    linetype 1 linewidth 1 \
    pointtype 11 pointsize 0.5

set style line 6 \
    linecolor rgb '#900040' \
    linetype 1 linewidth 1 \
    pointtype 17 pointsize 0.5

set style line 7 \
    linecolor rgb '#300090' \
    linetype 1 linewidth 1 \
    pointtype 17 pointsize 0.5

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set yrange [0.5:]
set ytics 1 nomirror out
set xtics rotate 3600*24*365.25 nomirror out
unset mxtics

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/tls-over-time.csv' using 1:3 with linespoints linestyle 1 title "TLS", \
 ARG1.'/ssh-over-time.csv' using 1:3 with linespoints linestyle 2 title "SSH", \
 ARG1.'/h1-over-time.csv' using 1:3 with linespoints linestyle 4 title "HTTP/1", \
 ARG1.'/h2-over-time.csv' using 1:3 with linespoints linestyle 5 title "HTTP/2", \
 ARG1.'/h3-over-time.csv' using 1:3 with linespoints linestyle 3 title "HTTP/3", \
 ARG1.'/idn-over-time.csv' using 1:3 with linespoints linestyle 6 title "IDN", \
 ARG1.'/resolver-over-time.csv' using 1:3 with linespoints linestyle 7 title "resolver", \
ARG1.'/tls-over-time.csv' using 1:3:2 with labels right offset -0.5,0.2 font ",14" rotate by -22 tc "#0060ad" title "", \
 ARG1.'/ssh-over-time.csv' using 1:3:2 with labels right offset -0.5,0.2 font ",14" rotate by -22 tc "#808080" title "", \
 ARG1.'/h1-over-time.csv' using 1:3:2 with labels right offset -0.5,0.2 font ",14" rotate by -2 tc "#c000c0" title "", \
 ARG1.'/h2-over-time.csv' using 1:3:2 with labels right offset -0.5,0.2 font ",14" rotate by -22 tc "#c00040" title "", \
 ARG1.'/h3-over-time.csv' using 1:3:2 with labels right offset -0.5,0.2 font ",14" rotate by -22 tc "#c0c080" title "", \
 ARG1.'/idn-over-time.csv' using 1:3:2 with labels right offset -0.5,0.2 font ",14" rotate by -22 tc "#900040" title "", \
 ARG1.'/resolver-over-time.csv' using 1:3:2 with labels right offset -0.5,0.2 font ",14" rotate by -22 tc "#300090" title ""
