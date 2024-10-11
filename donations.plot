# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Open Collective Donations to curl" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Donated USD per month"
set ytics nomirror

set y2label "Net total amount of donations (USD)"
set y2tics 

set style line 1 \
    linecolor rgb '#c0c0ff' \
    linetype 1 linewidth 2

set style line 2 \
    linecolor rgb '#ff60ad' \
    dt 1 linewidth 4

set style line 3 \
    linecolor rgb '#00c000' \
    dt 1 linewidth 3

set boxwidth 0.8 relative
set style fill solid

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

set xrange ["2018-03-15":]

hour = 60*60
day = 24*hour

set xtics 30*day rotate nomirror

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%b %Y"
set datafile separator ";"

plot 'tmp/donations.csv' using 1:2 with boxes linestyle 1 title "Monthly amount (before fees)", \
  'tmp/donations.csv' using 1:3 with lines linestyle 2 title "12 month average", \
  'tmp/donations.csv' using 1:5 with lines linestyle 3 title "All-time monthly average", \
  'tmp/donations.csv' using 1:4 with lines title "Total net amount" axis x1y2 lw 4
