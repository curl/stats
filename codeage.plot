# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Source code age\n{/*0.5Lines of code written per two-year segment}" font ",48"
# where's the legend
set key left top font ",22"

# Identify the axes
#set xlabel "Time"
set y2label "Lines of code (including blanks and comments)"

set grid y2tics
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set y2range [0:]
set xrange ["2000-01-01":]

set xtics rotate 3600*24*365.25 nomirror out
unset mxtics
#set ytics out
set y2tics mirror out
unset ytics

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30

# set the format of the dates on the x axis
set format x "%Y"

# instead of, e.g.,  200000, show 200k
set format y2 "%.0s%c"

set datafile separator ";"
plot 'tmp/codeage.csv' using 1:15 axes x1y2 with filledcurves above fc "#fe0000" title "≥ 2024", \
 'tmp/codeage.csv' using 1:14 axes x1y2 with filledcurves above fc "#001280" title "≥ 2022", \
 'tmp/codeage.csv' using 1:13 axes x1y2 with filledcurves above fc "#ffd800" title "≥ 2020", \
 'tmp/codeage.csv' using 1:12 axes x1y2 with filledcurves above fc "#007f0e" title "≥ 2018", \
 'tmp/codeage.csv' using 1:11 axes x1y2 with filledcurves above fc "#0094fe" title "≥ 2016", \
 'tmp/codeage.csv' using 1:10 axes x1y2 with filledcurves above fc "#00fe21" title "≥ 2014", \
 'tmp/codeage.csv' using 1:9 axes x1y2 with filledcurves above fc "#b100fe" title "≥ 2012", \
 'tmp/codeage.csv' using 1:8 axes x1y2 with filledcurves above fc "#800001" title "≥ 2010", \
 'tmp/codeage.csv' using 1:7 axes x1y2 with filledcurves above fc "#0026ff" title "≥ 2008", \
 'tmp/codeage.csv' using 1:6 axes x1y2 with filledcurves above fc "#806b00" title "≥ 2006", \
 'tmp/codeage.csv' using 1:5 axes x1y2 with filledcurves above fc "#803400" title "≥ 2004", \
 'tmp/codeage.csv' using 1:4 axes x1y2 with filledcurves above fc "#00497e" title "≥ 2002", \
 'tmp/codeage.csv' using 1:3 axes x1y2 with filledcurves above fc "#fe6a00" title "≥ 2000", \
 'tmp/codeage.csv' using 1:2 axes x1y2 with filledcurves above fc "#590080" title "< 2000"
