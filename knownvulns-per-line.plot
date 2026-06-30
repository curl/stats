# SVG output
load "stats/terminal.include"

set title "Vulnerability density" font ",48"
set key top right

# Identify the axes
set ylabel "Number of known CVEs present / KLOC"

set grid
unset border

set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror
set ytics out
unset mxtics
set yrange [0:]
set xrange ["1998-01-01":]

load "stats/logo.include"

set format x "%Y"
set datafile separator ";"
plot ARG1.'/known-low-per-line.csv' using 1:2 with filledcurves fc "#2e8a00" title "Low", \
 ARG1.'/known-med-per-line.csv' using 1:2 with filledcurves fc "#0080c0" title "Medium", \
 ARG1.'/known-high-per-line.csv' using 1:2 with filledcurves fc "#800000" title "High", \
 ARG1.'/known-crit-per-line.csv' using 1:2 with filledcurves fc "#fe0000" title "Critical"
