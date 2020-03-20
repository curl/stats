#!bin/sh

# store the CSV intermediate files here
temp=tmp
# store the SVG output here
output=`mktemp --tmpdir=tmp -d svg-XXX`

perl stats/authors-per-year.pl > $temp/authors-per-year.csv
gnuplot -c stats/authors-per-year.plot > $output/authors-per-year.svg

perl stats/commits-per-year.pl > $temp/commits-per-year.csv
gnuplot -c stats/commits-per-year.plot > $output/commits-per-year.svg

perl stats/coreteam-over-time.pl | grep "^[12]" | tr -d '(' | awk '{ print $1"-01-01;"$2; }' > $temp/coreteam-per-year.csv
gnuplot -c stats/coreteam-per-year.plot > $output/coreteam-per-year.svg

perl stats/setopts-over-time.pl | cut '-d;' -f2- > $temp/setopts-over-time.csv
gnuplot -c stats/setopts-over-time.plot > $output/setopts-over-time.svg

perl stats/days-per-release.pl | cut '-d;' -f2- > $temp/days-per-release.csv
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

perl stats/vulns-per-year.pl > $temp/vulns-per-year.csv
gnuplot -c stats/vulns-per-year.plot > $output/vulns-per-year.svg

perl stats/cve-plot.pl > $temp/cve-plot.csv
gnuplot -c stats/cve-plot.plot > $output/cve-plot.svg

perl stats/vulns-over-time.pl > $temp/vulns-over-time.csv
gnuplot -c stats/vulns-over-time.plot > $output/vulns-plot.svg

perl stats/lines-over-time.pl > $temp/lines-over-time.csv
gnuplot -c stats/lines-over-time.plot > $output/lines-over-time.svg

perl stats/tests-over-time.pl | cut '-d;' -f2- > tmp/tests-over-time.csv
# restore
git checkout master
gnuplot -c stats/tests-over-time.plot > $output/tests-over-time.svg

cat >stats.html <<EOF
<a href="$output/authors-per-year.svg"><img src="$output/authors-per-year.svg"></a>
<a href="$output/commits-per-year.svg"><img src="$output/commits-per-year.svg"></a>
<a href="$output/coreteam-per-year.svg"><img src="$output/coreteam-per-year.svg"></a>
<a href="$output/daniel-vs-rest.svg"><img src="$output/daniel-vs-rest.svg"></a>
<a href="$output/tests-over-time.svg"><img src="$output/tests-over-time.svg"></a>
<a href="$output/setopts-over-time.svg"><img src="$output/setopts-over-time.svg"></a>
<a href="$output/days-per-release.svg"><img src="$output/days-per-release.svg"></a>
<a href="$output/API-calls-over-time.svg"><img src="$output/API-calls-over-time.svg"></a>
<a href="$output/cmdline-options-over-time.svg"><img src="$output/cmdline-options-over-time.svg"></a>
<a href="$output/contributors-over-time.svg"><img src="$output/contributors-over-time.svg"></a>
<a href="$output/firsttimers.svg"><img src="$output/firsttimers.svg"></a>
<a href="$output/authors.svg"><img src="$output/authors.svg"></a>
<a href="$output/authors-per-month.svg"><img src="$output/authors-per-month.svg"></a>
<a href="$output/CI-jobs-over-time.svg"><img src="$output/CI-jobs-over-time.svg"></a>
<a href="$output/commits-per-month.svg"><img src="$output/commits-per-month.svg"></a>
<a href="$output/docs-over-time.svg"><img src="$output/docs-over-time.svg"></a>
<a href="$output/vulns-per-year.svg"><img src="$output/vulns-per-year.svg"></a>
<a href="$output/lines-over-time.svg"><img src="$output/lines-over-time.svg"></a>
<a href="$output/vulns-plot.svg"><img src="$output/vulns-plot.svg"></a>
<a href="$output/cve-plot.svg"><img src="$output/cve-plot.svg"></a>

EOF

# make the dir world readable
chmod 755 $output
