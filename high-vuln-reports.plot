# SVG output
set terminal svg size 1920,1080 dynamic font ",24"

# title
set title "Vulnerability severity since 2010\n{/*0.4per report date}" font ",48"
# where's the legend
set key top center

# Identify the axes
set ylabel "Number of reports / % of reports"
set grid
unset border

#set y2label "Share of reports high or critical" tc "#FF4040"
#set y2tics

# time formated using this format
set timefmt "%Y-%m-%d"
set xdata time

# set the format of the dates on the x axis
set format x "%Y"
set xtics rotate 3600*24*365.25 nomirror

set xrange ["2010-01-01":]
set y2range [0:]

set datafile separator ";"
plot \
 'tmp/high-vuln-reports.csv' using 1:3 with lines lw 3 title "Severity Low reports", \
 'tmp/high-vuln-reports.csv' using 1:4 with lines lw 3 title "Severity Medium reports", \
 'tmp/high-vuln-reports.csv' using 1:5 with lines lw 3 title "Severity High reports", \
 'tmp/high-vuln-reports.csv' using 1:6 with lines lw 3 title "Severity Critical reports", \
 'tmp/high-vuln-reports.csv' using 1:7 with lines lc "#000000" lw 3 title "% share reported High or Critical"
