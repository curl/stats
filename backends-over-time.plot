# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "curl backends" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of backends"

set style line 1 \
    linecolor rgb '#0060ad' \
    linetype 2 linewidth 1 \
    pointtype 7

set style line 2 \
    linecolor rgb '#808080' \
    linetype 1 linewidth 1 \
    pointtype 7

set style line 3 \
    linecolor rgb '#c0c080' \
    linetype 1 linewidth 1 \
    pointtype 7

set style line 4 \
    linecolor rgb '#c000c0' \
    linetype 1 linewidth 1 \
    pointtype 7

set style line 5 \
    linecolor rgb '#c00040' \
    linetype 1 linewidth 1 \
    pointtype 11

set style line 6 \
    linecolor rgb '#900040' \
    linetype 1 linewidth 1 \
    pointtype 17

set style line 7 \
    linecolor rgb '#300090' \
    linetype 1 linewidth 1 \
    pointtype 17

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set yrange [0:]
set ytics 1
set xtics rotate 3600*24*365.25 nomirror

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot 'tmp/tls-over-time.csv' using 1:3 with linespoints linestyle 1 title "TLS", \
 'tmp/ssh-over-time.csv' using 1:3 with linespoints linestyle 2 title "SSH", \
 'tmp/h1-over-time.csv' using 1:3 with linespoints linestyle 4 title "HTTP/1", \
 'tmp/h2-over-time.csv' using 1:3 with linespoints linestyle 5 title "HTTP/2", \
 'tmp/h3-over-time.csv' using 1:3 with linespoints linestyle 3 title "HTTP/3", \
 'tmp/idn-over-time.csv' using 1:3 with linespoints linestyle 6 title "IDN", \
 'tmp/resolver-over-time.csv' using 1:3 with linespoints linestyle 7 title "resolver", \
'tmp/tls-over-time.csv' using 1:3:2 with labels center offset -2,1 font ",14" rotate by -22 tc "#0060ad" title "", \
 'tmp/ssh-over-time.csv' using 1:3:2 with labels offset -2,1 font ",14" rotate by -22 tc "#808080" title "", \
 'tmp/h1-over-time.csv' using 1:3:2 with labels offset -3,0.4 font ",14" rotate by -22 tc "#c000c0" title "", \
 'tmp/h2-over-time.csv' using 1:3:2 with labels offset -3,0.5 font ",14" rotate by -22 tc "#c00040" title "", \
 'tmp/h3-over-time.csv' using 1:3:2 with labels offset -2,1 font ",14" rotate by -22 tc "#c0c080" title "", \
 'tmp/idn-over-time.csv' using 1:3:2 with labels offset -1,1 font ",14" rotate by -22 tc "#900040" title "", \
 'tmp/resolver-over-time.csv' using 1:3:2 with labels offset -1,1 font ",14" rotate by -22 tc "#300090" title ""
