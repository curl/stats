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
set xtics rotate time 1 years nomirror out
set ytics out
unset mxtics

load "stats/logo.include"

set yrange [0:]

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"
plot ARG1.'/complex-dist.csv' using 1:14 with filledcurves above fc "#A60000" title "> 200", \
 ARG1.'/complex-dist.csv' using 1:13 with filledcurves above fc "#FF6F00" title "≤ 200", \
 ARG1.'/complex-dist.csv' using 1:12 with filledcurves above fc "#E6B800" title "≤ 150", \
 ARG1.'/complex-dist.csv' using 1:11 with filledcurves above fc "#4B6A00" title "≤ 100", \
 ARG1.'/complex-dist.csv' using 1:10 with filledcurves above fc "#00E676" title "≤ 90", \
 ARG1.'/complex-dist.csv' using 1:9 with filledcurves above fc "#005B5C" title "≤ 80", \
 ARG1.'/complex-dist.csv' using 1:8 with filledcurves above fc "#00B0FF" title "≤ 70", \
 ARG1.'/complex-dist.csv' using 1:7 with filledcurves above fc "#0D47A1" title "≤ 60", \
 ARG1.'/complex-dist.csv' using 1:6 with filledcurves above fc "#651FFF" title "≤ 50", \
 ARG1.'/complex-dist.csv' using 1:5 with filledcurves above fc "#4A0072" title "≤ 40", \
 ARG1.'/complex-dist.csv' using 1:4 with filledcurves above fc "#FF007F" title "≤ 30", \
 ARG1.'/complex-dist.csv' using 1:3 with filledcurves above fc "#FF8A80" title "≤ 20", \
 ARG1.'/complex-dist.csv' using 1:2 with filledcurves above fc "#5D001E" title "≤ 10"
