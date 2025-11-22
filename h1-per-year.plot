# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Hackerone reports per year" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Years"
set ylabel "Number of reports"

# for the boxes
set boxwidth 0.5 relative
set style fill solid 0.5

set grid ytics
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

# start Y at 0
set yrange [0:]

# the dates need to be manipulated as strings - you can't do numerical arithmetic on them.
# / Lee Philips

dayoffset = '30'
set xrange ["2018-06-01":]
set xtics 3600*24*365.25 nomirror out
unset mxtics
set ytics nomirror

plot 'stats/h1-reports.md' using (strcol(1)[1:8].dayoffset*2):4 with boxes title "AI slop" fc 'blue', \
 'stats/h1-reports.md' using 1:2 with boxes title "All reports" fc 'red', \
 'stats/h1-reports.md' using (strcol(1)[1:8].dayoffset):3 with boxes title "Confirmed vulnerabilities" fc 'green', \
 'stats/h1-reports.md' using 1:2:2 with labels title "" offset 0,.5 font ", 24" tc lt 1, \
 'stats/h1-reports.md' using 1:3:3 with labels title "" offset -4.5,.5 font ", 24" tc lt 6, \
 'stats/h1-reports.md' using 1:4:4 with labels title "" offset 5,.5 font ", 24" tc lt 0
