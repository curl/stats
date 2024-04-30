# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Authors with code left in product code\n{/*0.6lines attributed to them by git blame -CCC in src/, lib/ or include/}" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of authors"

set style line 1 \
    linecolor rgb '#0060ad' \
    linewidth 2
set style line 2 \
    linecolor rgb '#40c040' \
    linewidth 2
set style line 3 \
    linecolor rgb '#f0c040' \
    linewidth 2
set style line 4 \
    linecolor rgb '#40f0f0' \
    linewidth 2
set style line 5 \
    linecolor rgb '#f03030' \
    linewidth 2
set style line 6 \
    linecolor rgb '#808080' \
    linewidth 2

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set xrange ["2010-01-01":]

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set datafile separator ";"
plot 'tmp/authorremains.csv' using 1:2 with lines linestyle 1 title "one line or more", \
 'tmp/authorremains.csv' using 1:3 with lines linestyle 2 title "10 lines or more", \
 'tmp/authorremains.csv' using 1:4 with lines linestyle 3 title "100 lines or more", \
 'tmp/authorremains.csv' using 1:5 with lines linestyle 4 title "1,000 lines or more", \
 'tmp/authorremains.csv' using 1:6 with lines linestyle 5 title "10,000 lines or more"
