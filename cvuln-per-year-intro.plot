# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Vulnerability reports C mistakes vs not C mistakes\n{/*0.6per year the vulnerability was introduced}" font ",48"
# where's the legend
set key top right

# Identify the axes
set ylabel "Number of such vulnerabilities introduced that year"

# for the boxes
set boxwidth 0.6 relative
set style fill solid 0.8

set grid ytics mytics
unset border

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

dayoffset = '90'

set xtics rotate 3600*24*365.25 nomirror out
set xrange ["1997-08-01":]
set ytics nomirror

load "stats/logo.include"

# set the format of the dates on the x axis
set format x "%Y"
set datafile separator ";"

# plot the flaw periods and the project age with titles and line width 3
plot ARG1.'/cvuln-per-year-intro.csv' using 1:2 with boxes title "C mistake" fc '#800000', \
  ARG1.'/cvuln-per-year-intro.csv' using (strcol(1)[1:8].dayoffset):3 with boxes title "Not a C mistake" fc '#4040c0'
