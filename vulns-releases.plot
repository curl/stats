# SVG output
load "stats/terminal.include"

# title
set title "Vulnerabilities in releases\n{/*0.4Every 4th release has a label}" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of vulnerabilities"

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xtics 3600*24*365.25 nomirror rotate
unset mxtics
set ytics 5

set boxwidth 0.8 relative
set style fill solid

#set xrange ["2020-01-01":]

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set xtics out
set datafile separator ";"
set key autotitle col
plot ARG1.'/vulns-releases.csv' using 1:3 with points pt 1 ps 0.4 title "",\
  ARG1.'/vulns-releases.csv' using 1:3:2 every 4 with labels left offset 0,.2 font ", 14" rotate by 90 title ""
