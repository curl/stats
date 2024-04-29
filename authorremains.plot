# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Authors with code left in product code\n{/*0.6 at least one line attributed to them by git blame -CCC in src/, lib/ or include/}" font ",48"
# where's the legend
set key top left

# Identify the axes
#set xlabel "Time"
set ylabel "Number of authors"

set style line 1 \
    linecolor rgb '#8060ad' \
    linetype 1 linewidth 3

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set datafile separator ";"
plot 'tmp/authorremains.csv' using 1:2 with lines linestyle 1 title ""
