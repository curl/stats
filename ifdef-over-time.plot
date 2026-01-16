# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "#if density\n{/*0.6#if, #elif, #ifdef and #ifndef instances in product code}" font ",48"
# where's the legend
set key bottom right

# Identify the axes
set ylabel "#if lines per KLOC (excl comments)"
set y2label "Number of #if condition lines"
set y2tics

set style line 1 \
    linecolor rgb '#c060ad' \
    linetype 1 dt "_" linewidth 3

set style line 2 \
    linecolor rgb '#c0c04d' \
    linetype 1 linewidth 3

set ytics nomirro

set grid
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time
set yrange [0:]

set pixmap 1 "stats/curl-symbol-light.png"
set pixmap 1 at screen 0.35, 0.30 width screen 0.30 behind

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror
unset mxtics
set datafile separator ";"
plot 'tmp/ifdef-over-time.csv' using 1:2 with lines linestyle 1 title "#if lines" axis x1y2, \
'tmp/ifdef-per-kloc.csv' using 1:2 with lines linestyle 2 title "#if lines per KLOC"
