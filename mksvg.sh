#!bin/sh

# custom dir for the web root directory
webroot=$1

# store the CSV intermediate files here
temp=tmp
# store the SVG output here
output=`mktemp -d svg-XXXXXX`

perl stats/mail.pl > $temp/mail.csv
gnuplot -c stats/mail.plot > $output/mail.svg

perl stats/gh-monthly.pl stats/csv/github.csv > $temp/gh-monthly.csv
gnuplot -c stats/gh-monthly.plot > $output/gh-monthly.svg

perl stats/gh-age.pl stats/csv/github.csv > $temp/gh-age.csv
gnuplot -c stats/gh-age.plot > $output/gh-age.svg

perl stats/files-over-time.pl > $temp/files-over-time.csv
gnuplot -c stats/files-over-time.plot > $output/files-over-time.svg

perl stats/bugfix-frequency.pl $webroot > $temp/bugfix-frequency.csv
gnuplot -c stats/bugfix-frequency.plot > $output/bugfix-frequency.svg

perl stats/API-calls-over-time.pl | cut "-d;" -f2- > $temp/API-calls-over-time.csv
gnuplot -c stats/API-calls-over-time.plot > $output/API-calls-over-time.svg

perl stats/protocols-over-time.pl > $temp/protocols-over-time.csv
gnuplot -c stats/protocols-over-time.plot > $output/protocols-over-time.svg

perl stats/tls-over-time.pl > $temp/tls-over-time.csv
gnuplot -c stats/tls-over-time.plot > $output/tls-over-time.svg

perl stats/daniel-vs-rest.pl > $temp/daniel-vs-rest.csv
gnuplot -c stats/daniel-vs-rest.plot > $output/daniel-vs-rest.svg

perl stats/authors-per-year.pl > $temp/authors-per-year.csv
gnuplot -c stats/authors-per-year.plot > $output/authors-per-year.svg

perl stats/commits-per-year.pl > $temp/commits-per-year.csv
gnuplot -c stats/commits-per-year.plot > $output/commits-per-year.svg

perl stats/coreteam-over-time.pl | grep "^[12]" | tr -d '(' | awk '{ print $1"-01-01;"$2; }' > $temp/coreteam-per-year.csv
gnuplot -c stats/coreteam-per-year.plot > $output/coreteam-per-year.svg

perl stats/setopts-over-time.pl | cut '-d;' -f2- > $temp/setopts-over-time.csv
gnuplot -c stats/setopts-over-time.plot > $output/setopts-over-time.svg

perl stats/days-per-release.pl $webroot $temp/days-per-release.csv
gnuplot -c stats/days-per-release.plot > $output/days-per-release.svg

perl stats/cmdline-options-over-time.pl | cut '-d;' -f2- > $temp/cmdline-options-over-time.csv
gnuplot -c stats/cmdline-options-over-time.plot > $output/cmdline-options-over-time.svg

perl stats/contributors-over-time.pl | cut '-d;' -f2- > $temp/contributors-over-time.csv
gnuplot -c stats/contributors-over-time.plot > $output/contributors-over-time.svg

perl stats/authors.pl > $temp/authors.csv
gnuplot -c stats/authors.plot > $output/authors.svg

perl stats/todo-over-time.pl > $temp/todo-over-time.csv
gnuplot -c stats/todo-over-time.plot > $output/todo-over-time.svg

perl stats/authors-per-month.pl > $temp/authors-per-month.csv
gnuplot -c stats/authors-per-month.plot > $output/authors-per-month.svg

perl stats/firsttimers.pl > $temp/firsttimers.csv
gnuplot -c stats/firsttimers.plot > $output/firsttimers.svg

perl stats/CI-jobs-over-time.pl | cut '-d;' -f2-  > $temp/CI.csv
gnuplot -c stats/CI-jobs-over-time.plot > $output/CI-jobs-over-time.svg

perl stats/CI-platforms.pl > $temp/CI-platforms.csv
gnuplot -c stats/CI-platforms.plot > $output/CI-platforms.svg

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

perl stats/lines-per-month.pl > $temp/lines-per-month.csv
gnuplot -c stats/lines-per-month.plot > $output/lines-per-month.svg

perl stats/tests-over-time.pl | cut '-d;' -f2- > $temp/tests-over-time.csv
gnuplot -c stats/tests-over-time.plot > $output/tests-over-time.svg

perl stats/bugbounty-over-time.pl $webroot > $temp/bugbounty-over-time.csv
gnuplot -c stats/bugbounty-over-time.plot > $output/bugbounty-over-time.svg

perl stats/contributors-per-release.pl > $temp/contributors-per-release.csv
gnuplot -c stats/contributors-per-release.plot > $output/contributors-per-release.svg

cat >stats.list <<EOF
api-calls = $output/API-calls-over-time.svg
authors = $output/authors.svg
authors-per-month = $output/authors-per-month.svg
authors-per-year = $output/authors-per-year.svg
bugbounty = $output/bugbounty-over-time.svg
bugfix-frequency = $output/bugfix-frequency.svg
ci-jobs = $output/CI-jobs-over-time.svg
ci-platforms = $output/CI-platforms.svg
cmdline-options-over-time = $output/cmdline-options-over-time.svg
commits-per-month = $output/commits-per-month.svg
commits-per-year = $output/commits-per-year.svg
contribs-release = $output/contributors-per-release.svg
contributors = $output/contributors-over-time.svg
coreteam-per-year = $output/coreteam-per-year.svg
cve-time = $output/cve-plot.svg
daniel-vs-rest = $output/daniel-vs-rest.svg
days-per-release = $output/days-per-release.svg
docs = $output/docs-over-time.svg
files = $output/files-over-time.svg
firsttimers = $output/firsttimers.svg
github-monthly = $output/gh-monthly.svg
github-age = $output/gh-age.svg
loc = $output/lines-over-time.svg
deltaloc = $output/lines-per-month.svg
mail = $output/mail.svg
protocols = $output/protocols-over-time.svg
setopts = $output/setopts-over-time.svg
tests = $output/tests-over-time.svg
todo = $output/todo-over-time.svg
tls-backends = $output/tls-over-time.svg
vulns-per-year = $output/vulns-per-year.svg
vulns-plot = $output/vulns-plot.svg
EOF

# Use the same names but point to the used CSV/data/input file
cat >stats.data <<EOF
api-calls = $temp/API-calls-over-time.csv
authors = $temp/authors.csv
authors-per-month = $temp/authors-per-month.csv
authors-per-year = $temp/authors-per-year.csv
bugbounty = $temp/bugbounty-over-time.csv
bugfix-frequency = $temp/bugfix-frequency.csv
ci-jobs = $temp/CI.csv
ci-platforms = $temp/CI-platforms.csv
cmdline-options-over-time = $temp/cmdline-options-over-time.csv
commits-per-month = $temp/commits-per-month.csv
commits-per-year = $temp/commits-per-year.csv
contribs-release = $temp/contributors-per-release.csv
contributors = $temp/contributors-over-time.csv
coreteam-per-year = $temp/coreteam-per-year.csv
cve-time = $temp/cve-plot.csv
daniel-vs-rest = $temp/daniel-vs-rest.csv
days-per-release = $temp/days-per-release.csv
docs = $temp/docs-over-time.csv
files = $temp/files-over-time.csv
firsttimers = $temp/authors-per-month.csv
github-monthly = $temp/gh-monthly.csv
github-age = $temp/gh-age.csv
loc = $temp/lines-over-time.csv
deltaloc = $temp/lines-per-month.csv
mail = $temp/mail.csv
protocols = $temp/protocols-over-time.csv
setopts = $temp/setopts-over-time.csv
tests = $temp/tests-over-time.csv
todo = $temp/todo-over-time.csv
tls-backends = $temp/tls-over-time.csv
vulns-per-year = $temp/vulns-per-year.csv
vulns-plot = $temp/vulns-over-time.csv
EOF

# make the dir world readable
chmod 755 $output
