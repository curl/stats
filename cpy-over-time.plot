# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Lines of libcurl code per function use" font ",48"
# where's the legend
set key top left

# Identify the axes
set ylabel "Lines of code per function (excl comments)"

set style line 1 \
    linecolor rgb '#c060ad' \
    linetype 1 linewidth 3

set style line 2 \
    linecolor rgb '#c0c04d' \
    linetype 1 linewidth 3

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
set xrange ["2010-01-01":]
unset mxtics
set datafile separator ";"
plot 'tmp/cpy-over-time.csv' using 1:2 with lines linestyle 1 title "lines of code per (mem|str|strn)cpy", \
 'tmp/cpy-over-time.csv' using 1:4 with lines linestyle 2 title "lines of code per (re|m|c)alloc"
