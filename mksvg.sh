#!bin/sh

# custom dir for the web root directory
webroot=$1

# store the CSV intermediate files here
temp=tmp
# store the SVG output here
output=`mktemp -d svg-XXXXXX`

perl stats/bugfix-frequency.pl $webroot > $temp/bugfix-frequency.csv
gnuplot -c stats/bugfix-frequency.plot > $output/bugfix-frequency.svg

perl stats/API-calls-over-time.pl | cut "-d;" -f2- > $temp/API-calls-over-time.csv
gnuplot -c stats/API-calls-over-time.plot > $output/API-calls-over-time.svg

perl stats/protocols-over-time.pl > $temp/protocols-over-time.csv
gnuplot -c stats/protocols-over-time.plot > $output/protocols-over-time.svg

perl stats/tls-over-time.pl > $temp/tls-over-time.csv
gnuplot -c stats/tls-over-time.plot > $output/tls-over-time.svg

perl stats/daniel-vs-rest.pl | cut '-d;' -f1,3 > $temp/daniel-vs-rest.csv
gnuplot -c stats/daniel-vs-rest.plot > $output/daniel-vs-rest.svg

perl stats/authors-per-year.pl > $temp/authors-per-year.csv
gnuplot -c stats/authors-per-year.plot > $output/authors-per-year.svg

perl stats/commits-per-year.pl > $temp/commits-per-year.csv
gnuplot -c stats/commits-per-year.plot > $output/commits-per-year.svg

perl stats/coreteam-over-time.pl | grep "^[12]" | tr -d '(' | awk '{ print $1"-01-01;"$2; }' > $temp/coreteam-per-year.csv
gnuplot -c stats/coreteam-per-year.plot > $output/coreteam-per-year.svg

perl stats/setopts-over-time.pl | cut '-d;' -f2- > $temp/setopts-over-time.csv
gnuplot -c stats/setopts-over-time.plot > $output/setopts-over-time.svg

perl stats/days-per-release.pl $webroot | cut '-d;' -f2- > $temp/days-per-release.csv
gnuplot -c stats/days-per-release.plot > $output/days-per-release.svg

perl stats/cmdline-options-over-time.pl | cut '-d;' -f2- > $temp/cmdline-options-over-time.csv
gnuplot -c stats/cmdline-options-over-time.plot > $output/cmdline-options-over-time.svg

perl stats/contributors-over-time.pl | cut '-d;' -f2- > tmp/contributors-over-time.csv
gnuplot -c stats/contributors-over-time.plot > $output/contributors-over-time.svg

perl stats/authors-per-month.pl > $temp/authors-per-month.csv
gnuplot -c stats/authors-per-month.plot > $output/authors-per-month.svg
gnuplot -c stats/authors.plot > $output/authors.svg
gnuplot -c stats/firsttimers.plot > $output/firsttimers.svg

perl stats/CI-jobs-over-time.pl | cut '-d;' -f2-  > tmp/CI.csv
gnuplot -c stats/CI-jobs-over-time.plot > $output/CI-jobs-over-time.svg

perl stats/commits-per-month.pl > $temp/commits-per-month.csv
gnuplot -c stats/commits-per-month.plot > $output/commits-per-month.svg

perl stats/docs-over-time.pl > $temp/docs-over-time.csv
gnuplot -c stats/docs-over-time.plot > $output/docs-over-time.svg

perl stats/vulns-per-year.pl $webroot > $temp/vulns-per-year.csv
gnuplot -c stats/vulns-per-year.plot > $output/vulns-per-year.svg

perl stats/cve-plot.pl $webroot > $temp/cve-plot.csv
gnuplot -c stats/cve-plot.plot > $output/cve-plot.svg

perl stats/vulns-over-time.pl $webroot > $temp/vulns-over-time.csv
gnuplot -c stats/vulns-over-time.plot > $output/vulns-plot.svg

perl stats/lines-over-time.pl > $temp/lines-over-time.csv
gnuplot -c stats/lines-over-time.plot > $output/lines-over-time.svg

perl stats/tests-over-time.pl | cut '-d;' -f2- > tmp/tests-over-time.csv
gnuplot -c stats/tests-over-time.plot > $output/tests-over-time.svg

cat >stats.list <<EOF
API-calls-over-time = $output/API-calls-over-time.svg
authors-per-month = $output/authors-per-month.svg
authors-per-year = $output/authors-per-year.svg
authors = $output/authors.svg
bugfix-frequency = $output/bugfix-frequency.svg
CI-jobs-over-time = $output/CI-jobs-over-time.svg
cmdline-options-over-time = $output/cmdline-options-over-time.svg
commits-per-month = $output/commits-per-month.svg
commits-per-year = $output/commits-per-year.svg
contributors-over-time = $output/contributors-over-time.svg
coreteam-per-year = $output/coreteam-per-year.svg
cve-plot = $output/cve-plot.svg
daniel-vs-rest = $output/daniel-vs-rest.svg
days-per-release = $output/days-per-release.svg
docs-over-time = $output/docs-over-time.svg
firsttimers = $output/firsttimers.svg
lines-over-time = $output/lines-over-time.svg
protocols-over-time = $output/protocols-over-time.svg
setopts-over-time = $output/setopts-over-time.svg
tests-over-time = $output/tests-over-time.svg
tls-over-time = $output/tls-over-time.svg
vulns-per-year = $output/vulns-per-year.svg
vulns-plot = $output/vulns-plot.svg
EOF

# make the dir world readable
chmod 755 $output
