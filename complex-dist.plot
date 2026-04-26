# SVG output
load "stats/terminal.include"

# title
set title "Complexity distribution\n{/*0.4How big share of the source code is considered how complex}" font ",48"
# where's the legend
set key center right outside

# Identify the axes
#set xlabel "Time"
set ylabel "Percentage share of the product code"

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics rotate 3600*24*365.25 nomirror out
set ytics out
unset mxtics

load "stats/logo.include"

set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/complex-dist.csv' using 1:12 with filledcurves above fc "#A80003" title "> 200", \
 ARG1.'/complex-dist.csv' using 1:11 with filledcurves above fc "#E40515" title "≤ 200", \
 ARG1.'/complex-dist.csv' using 1:10 with filledcurves above fc "#F94902" title "≤ 150", \
 ARG1.'/complex-dist.csv' using 1:9 with filledcurves above fc "#F6790B" title "≤ 100", \
 ARG1.'/complex-dist.csv' using 1:8 with filledcurves above fc "#F19903" title "≤ 90", \
 ARG1.'/complex-dist.csv' using 1:7 with filledcurves above fc "#E7B503" title "≤ 80", \
 ARG1.'/complex-dist.csv' using 1:6 with filledcurves above fc "#D5CE04" title "≤ 70", \
 ARG1.'/complex-dist.csv' using 1:5 with filledcurves above fc "#BBE453" title "≤ 60", \
 ARG1.'/complex-dist.csv' using 1:4 with filledcurves above fc "#A2F49B" title "≤ 50", \
 ARG1.'/complex-dist.csv' using 1:3 with filledcurves above fc "#C6F7D6" title "≤ 30", \
 ARG1.'/complex-dist.csv' using 1:2 with filledcurves above fc "#CEFFFF" title "≤ 10"
