# SVG output
load "stats/terminal.include"

# title
set title "C mistakes among the vulnerabilities present in code" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Number of vulnerabilities existing in code"
set y2label "C mistake share" tc "#800080"
set y2tics

# for the boxes
set boxwidth 0.6 relative
set style fill solid 0.8

set grid ytics mytics
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set xtics rotate 3600*24*365.25 nomirror out
set ytics nomirror
set xrange ["1998-01-01":]
set yrange [0.1:]
#set mxtics 1

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

set style line 1 \
    linecolor rgb '#800080' \
    linetype 2 dt "." linewidth 3

plot \
ARG1.'/c-vuln-code.csv' using 1:3 with filledcurves above fc "#2e8a00" title "All vulnerabilities", \
ARG1.'/c-vuln-code.csv' using 1:4 with filledcurves above fc "#a04040" title "C mistakes", \
ARG1.'/c-vuln-code.csv' using 1:5 smooth bezier with lines linestyle 1 title "C mistake share" axis x1y2
