# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Daniel Stenberg's share of committing changes\n{/*0.6separate from actually authoring the change}" font ",48"
# where's the legend
set key top center font ",20"

# Identify the axes
#set xlabel "Time"
set ylabel "Percentage"

set style line 1 \
    linecolor rgb '#f08040' \
    linetype 1 linewidth 5

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set ytics 10

set yrange [0:]
set xrange ["1999-10-01":]

set boxwidth 0.5 relative
set style fill solid

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25

set datafile separator ";"
plot  'tmp/daniel-commit-share.csv' using 1:3 with boxes linestyle 3 title "Monthly share of commits", \
'tmp/daniel-commit-share.csv' using 1:2 with lines linestyle 1 title "total share of commits"
