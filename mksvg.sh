#!bin/sh

# custom dir for the web root directory
webroot=$1

# store the CSV intermediate files here
temp=tmp
# store the SVG output here
output=`mktemp -d svg-XXXXXX`

perl stats/contrib-tail.pl > $temp/contrib-tail.csv
gnuplot -c stats/contrib-tail.plot > $output/contrib-tail.svg

perl stats/mail.pl > $temp/mail.csv
gnuplot -c stats/mail.plot > $output/mail.svg

perl stats/github-json.pl > $temp/github.csv
perl stats/gh-monthly.pl $temp/github.csv > $temp/gh-monthly.csv
gnuplot -c stats/gh-monthly.plot > $output/gh-monthly.svg

perl stats/gh-open.pl $temp/github.csv > $temp/gh-open.csv
gnuplot -c stats/gh-open.plot > $output/gh-open.svg

perl stats/gh-age.pl $temp/github.csv > $temp/gh-age.csv
gnuplot -c stats/gh-age.plot > $output/gh-age.svg

perl stats/gh-fixes.pl $temp/github.csv > $temp/gh-fixes.csv
gnuplot -c stats/gh-fixes.plot > $output/gh-fixes.svg

perl stats/files-over-time.pl > $temp/files-over-time.csv
gnuplot -c stats/files-over-time.plot > $output/files-over-time.svg

perl stats/bugfix-frequency.pl $webroot > $temp/bugfix-frequency.csv
gnuplot -c stats/bugfix-frequency.plot > $output/bugfix-frequency.svg

perl stats/API-calls-over-time.pl | cut "-d;" -f2- > $temp/API-calls-over-time.csv
gnuplot -c stats/API-calls-over-time.plot > $output/API-calls-over-time.svg

perl stats/protocols-over-time.pl > $temp/protocols-over-time.csv
gnuplot -c stats/protocols-over-time.plot > $output/protocols-over-time.svg

perl stats/tls-over-time.pl > $temp/tls-over-time.csv
perl stats/ssh-over-time.pl > $temp/ssh-over-time.csv
perl stats/h1-over-time.pl > $temp/h1-over-time.csv
perl stats/h2-over-time.pl > $temp/h2-over-time.csv
perl stats/h3-over-time.pl > $temp/h3-over-time.csv
perl stats/idn-over-time.pl > $temp/idn-over-time.csv
perl stats/resolver-over-time.pl > $temp/resolver-over-time.csv
gnuplot -c stats/backends-over-time.plot > $output/backends-over-time.svg

perl stats/3rdparty-over-time.pl > $temp/3rdparty-over-time.csv
gnuplot -c stats/3rdparty-over-time.plot > $output/3rdparty-over-time.svg

perl stats/http-over-time.pl > $temp/http-over-time.csv
gnuplot -c stats/http-over-time.plot > $output/http-over-time.svg

perl stats/daniel-vs-rest.pl > $temp/daniel-vs-rest.csv
gnuplot -c stats/daniel-vs-rest.plot > $output/daniel-vs-rest.svg

perl stats/daniel-commit-share.pl > $temp/daniel-commit-share.csv
gnuplot -c stats/daniel-commit-share.plot > $output/daniel-commit-share.svg

perl stats/authors-per-year.pl > $temp/authors-per-year.csv
gnuplot -c stats/authors-per-year.plot > $output/authors-per-year.svg

perl stats/commits-per-year.pl > $temp/commits-per-year.csv
gnuplot -c stats/commits-per-year.plot > $output/commits-per-year.svg

perl stats/commits-over-time.pl > $temp/commits-over-time.csv
gnuplot -c stats/commits-over-time.plot > $output/commits-over-time.svg

perl stats/coreteam-over-time.pl | grep "^[12]" | tr -d '(' | awk '{ print $1"-01-01;"$2; }' > $temp/coreteam-per-year.csv
perl stats/coreteam-over-time.pl | grep '^[12]' | cut -d" " -f 1,5 | tr -d '%' | awk '{ if($2 > 0) {print $1"-01-01;"$2; }}' > $temp/coreteam-percent.csv
gnuplot -c stats/coreteam-per-year.plot > $output/coreteam-per-year.svg

perl stats/80-percent.pl 95 > $temp/95-percent.csv
perl stats/80-percent.pl 90 > $temp/90-percent.csv
perl stats/80-percent.pl 80 > $temp/80-percent.csv
perl stats/80-percent.pl 70 > $temp/70-percent.csv
perl stats/80-percent.pl 60 > $temp/60-percent.csv
perl stats/80-percent.pl 50 > $temp/50-percent.csv
gnuplot -c stats/95-percent.plot > $output/95-percent.svg
gnuplot -c stats/90-percent.plot > $output/90-percent.svg
gnuplot -c stats/80-percent.plot > $output/80-percent.svg
gnuplot -c stats/70-percent.plot > $output/70-percent.svg
gnuplot -c stats/60-percent.plot > $output/60-percent.svg
gnuplot -c stats/50-percent.plot > $output/50-percent.svg

perl stats/comments.pl > $temp/comments.csv
gnuplot -c stats/comments.plot > $output/comments.svg

perl stats/filesize-over-time.pl > $temp/filesize-over-time.csv
gnuplot -c stats/filesize-over-time.plot > $output/filesize-over-time.svg

perl stats/setopts-over-time.pl | cut '-d;' -f2- > $temp/setopts-over-time.csv
gnuplot -c stats/setopts-over-time.plot > $output/setopts-over-time.svg

perl stats/days-per-release.pl $webroot > $temp/days-per-release.csv
gnuplot -c stats/days-per-release.plot > $output/days-per-release.svg

perl stats/cmdline-options-over-time.pl | cut '-d;' -f2- > $temp/cmdline-options-over-time.csv
gnuplot -c stats/cmdline-options-over-time.plot > $output/cmdline-options-over-time.svg

perl stats/contributors-over-time.pl | cut '-d;' -f2- > $temp/contributors-over-time.csv
gnuplot -c stats/contributors-over-time.plot > $output/contributors-over-time.svg

perl stats/authors.pl > $temp/authors.csv
gnuplot -c stats/authors.plot > $output/authors.svg

perl stats/authorremains.pl > $temp/authorremains.csv
gnuplot -c stats/authorremains.plot > $output/authorremains.svg
gnuplot -c stats/authorremains-top.plot > $output/authorremains-top.svg

perl stats/todo-over-time.pl > $temp/todo-over-time.csv
gnuplot -c stats/todo-over-time.plot > $output/todo-over-time.svg

perl stats/symbols-over-time.pl > $temp/symbols-over-time.csv
gnuplot -c stats/symbols-over-time.plot > $output/symbols-over-time.svg

perl stats/authors-per-month.pl > $temp/authors-per-month.csv
gnuplot -c stats/authors-per-month.plot > $output/authors-per-month.svg

perl stats/firsttimers.pl > $temp/firsttimers.csv
gnuplot -c stats/firsttimers.plot > $output/firsttimers.svg

perl stats/CI-jobs-over-time.pl | cut '-d;' -f2-  > $temp/CI.csv
gnuplot -c stats/CI-jobs-over-time.plot > $output/CI-jobs-over-time.svg
gnuplot -c stats/CI-services.plot > $output/CI-services.svg

perl stats/CI-platforms.pl > $temp/CI-platforms.csv
gnuplot -c stats/CI-platforms.plot > $output/CI-platforms.svg

perl stats/commits-per-month.pl > $temp/commits-per-month.csv
gnuplot -c stats/commits-per-month.plot > $output/commits-per-month.svg

perl stats/docs-over-time.pl > $temp/docs-over-time.csv
gnuplot -c stats/docs-over-time.plot > $output/docs-over-time.svg

perl stats/vulns-releases.pl $webroot > $temp/vulns-releases.csv
gnuplot -c stats/vulns-releases.plot > $output/vulns-releases.svg

perl stats/cve-age.pl $webroot > $temp/cve-age.csv
gnuplot -c stats/cve-age.plot > $output/cve-age.svg

perl stats/cve-fixtime.pl $webroot > $temp/cve-fixtime.csv
gnuplot -c stats/cve-fixtime.plot > $output/cve-fixtime.svg

perl stats/cve-intro.pl $webroot > $temp/cve-intro.csv
perl stats/vulns-over-time.pl $webroot > $temp/vulns-over-time.csv
gnuplot -c stats/vulns-over-time.plot > $output/vulns-plot.svg

perl stats/vulns-per-year.pl $webroot $temp/cve-intro.csv > $temp/vulns-per-year.csv
gnuplot -c stats/vulns-per-year.plot > $output/vulns-per-year.svg

perl stats/c-vuln-over-time.pl $webroot > $temp/c-vuln-over-time.csv
gnuplot -c stats/c-vuln-over-time.plot > $output/c-vulns.svg

perl stats/c-vuln-reports.pl $webroot > $temp/c-vuln-reports.csv
gnuplot -c stats/c-vuln-reports.plot > $output/c-reports.svg

perl stats/high-vuln-reports.pl $webroot > $temp/high-vuln-reports.csv
gnuplot -c stats/high-vuln-reports.plot > $output/high-reports.svg

perl stats/sev-per-year.pl $webroot > $temp/sev-per-year.csv
gnuplot -c stats/sev-per-year.plot > $output/sev-per-year.svg

perl stats/lines-over-time.pl > $temp/lines-over-time.csv
gnuplot -c stats/lines-over-time.plot > $output/lines-over-time.svg

perl stats/lines-per-month.pl > $temp/lines-per-month.csv
gnuplot -c stats/lines-per-month.plot > $output/lines-per-month.svg

perl stats/tests-over-time.pl > $temp/tests-over-time.csv
gnuplot -c stats/tests-over-time.plot > $output/tests-over-time.svg

perl stats/manpages-over-time.pl > $temp/manpages-over-time.csv
gnuplot -c stats/manpages-over-time.plot > $output/manpages-over-time.svg

perl stats/examples-over-time.pl > $temp/examples-over-time.csv
gnuplot -c stats/examples-over-time.plot > $output/examples-over-time.svg

perl stats/bugbounty-over-time.pl $webroot > $temp/bugbounty-over-time.csv
gnuplot -c stats/bugbounty-over-time.plot > $output/bugbounty-over-time.svg

perl stats/bugbounty-amounts.pl $webroot > $temp/bugbounty-amounts.csv
gnuplot -c stats/bugbounty-amounts.plot > $output/bugbounty-amounts.svg

perl stats/contributors-per-release.pl > $temp/contributors-per-release.csv
gnuplot -c stats/contributors-per-release.plot > $output/contributors-per-release.svg

perl stats/lines-person.pl > $temp/lines-person.csv
gnuplot -c stats/lines-person.plot > $output/lines-person.svg

perl stats/release-number.pl $webroot > $temp/release-number.csv
gnuplot -c stats/release-number.plot > $output/release-number.svg

perl stats/releases-per-year.pl $webroot > $temp/releases-per-year.csv
gnuplot -c stats/releases-per-year.plot > $output/releases-per-year.svg

perl stats/cpy-over-time.pl > $temp/cpy-over-time.csv
gnuplot -c stats/cpy-over-time.plot > $output/cpy-over-time.svg

# lines of docs per KLOC
#
# uses already generated CSV files to make a new one
perl stats/plotdivision.pl $temp/docs-over-time.csv $temp/lines-over-time.csv 0:1 0:1 1000 > $temp/lines-per-docs.csv
gnuplot -c stats/lines-per-docs.plot > $output/lines-per-docs.svg

# number of tests per KLOC

perl stats/plotdivision.pl $temp/tests-over-time.csv $temp/lines-over-time.csv  1:2 0:1 1000 > $temp/lines-per-test.csv
gnuplot -c stats/lines-per-test.plot > $output/lines-per-test.svg

# known vulnerability per KLOC

perl stats/plotdivision.pl $temp/vulns-releases.csv $temp/lines-over-time.csv 0:2 0:1 1000 > $temp/knownvulns-per-line.csv
gnuplot -c stats/knownvulns-per-line.plot > $output/knownvulns-per-line.svg

# authors and contributors per KLOC

perl stats/plotdivision.pl $temp/authors.csv $temp/lines-over-time.csv 0:2 0:1 1000 > $temp/lines-per-author.csv
perl stats/plotdivision.pl $temp/contributors-over-time.csv $temp/lines-over-time.csv 0:1 0:1 1000 > $temp/lines-per-contributor.csv
gnuplot -c stats/lines-per-author.plot > $output/lines-per-author.svg

# remaining authors per KLOC

perl stats/plotdivision.pl $temp/authorremains.csv $temp/lines-over-time.csv 0:1 0:1 1000 > $temp/remains-per-kloc.csv
gnuplot -c stats/remains-per-kloc.plot > $output/remains-per-kloc.svg

cat >stats.list <<EOF
95-percent = $output/95-percent.svg
90-percent = $output/90-percent.svg
80-percent = $output/80-percent.svg
70-percent = $output/70-percent.svg
60-percent = $output/60-percent.svg
50-percent = $output/50-percent.svg
api-calls = $output/API-calls-over-time.svg
authors = $output/authors.svg
authors-per-month = $output/authors-per-month.svg
authors-per-year = $output/authors-per-year.svg
authorremains = $output/authorremains.svg
authorremains-top = $output/authorremains-top.svg
backends = $output/backends-over-time.svg
bugbounty = $output/bugbounty-over-time.svg
bugbounty-amounts = $output/bugbounty-amounts.svg
bugfix-frequency = $output/bugfix-frequency.svg
c-vulns = $output/c-vulns.svg
c-reports = $output/c-reports.svg
ci-jobs = $output/CI-jobs-over-time.svg
ci-platforms = $output/CI-platforms.svg
ci-services = $output/CI-services.svg
cmdline-options-over-time = $output/cmdline-options-over-time.svg
comments = $output/comments.svg
commits = $output/commits-over-time.svg
commits-per-month = $output/commits-per-month.svg
commits-per-year = $output/commits-per-year.svg
contribs-release = $output/contributors-per-release.svg
contrib-tail = $output/contrib-tail.svg
contributors = $output/contributors-over-time.svg
coreteam-per-year = $output/coreteam-per-year.svg
cve-time = $output/cve-age.svg
daniel-commits = $output/daniel-commit-share.svg
daniel-vs-rest = $output/daniel-vs-rest.svg
days-per-release = $output/days-per-release.svg
deltaloc = $output/lines-per-month.svg
density = $output/remains-per-kloc.svg
docs = $output/docs-over-time.svg
examples = $output/examples-over-time.svg
files = $output/files-over-time.svg
filesize = $output/filesize-over-time.svg
firsttimers = $output/firsttimers.svg
fixtime = $output/cve-fixtime.svg
func-calls = $output/cpy-over-time.svg
github-age = $output/gh-age.svg
github-fixes = $output/gh-fixes.svg
github-monthly = $output/gh-monthly.svg
github-open = $output/gh-open.svg
high-vuln = $output/high-reports.svg
http-versions = $output/http-over-time.svg
lines = $output/lines-person.svg
lines-per-author = $output/lines-per-author.svg
lines-per-docs = $output/lines-per-docs.svg
lines-per-test = $output/lines-per-test.svg
loc = $output/lines-over-time.svg
mail = $output/mail.svg
manpages = $output/manpages-over-time.svg
protocols = $output/protocols-over-time.svg
releases = $output/release-number.svg
releases-per-year = $output/releases-per-year.svg
setopts = $output/setopts-over-time.svg
sev-per-year = $output/sev-per-year.svg
symbols = $output/symbols-over-time.svg
tests = $output/tests-over-time.svg
third-parties = $output/3rdparty-over-time.svg
todo = $output/todo-over-time.svg
vulns-per-year = $output/vulns-per-year.svg
vulns-plot = $output/vulns-plot.svg
vulns-releases = $output/vulns-releases.svg
vulns-per-kloc = $output/knownvulns-per-line.svg
EOF

# Use the same names but point to the used CSV/data/input file
cat >stats.data <<EOF
95-percent = $temp/80-percent.csv
90-percent = $temp/80-percent.csv
80-percent = $temp/80-percent.csv
70-percent = $temp/70-percent.csv
60-percent = $temp/60-percent.csv
50-percent = $temp/50-percent.csv
api-calls = $temp/API-calls-over-time.csv
authors = $temp/authors.csv
authors-per-month = $temp/authors-per-month.csv
authors-per-year = $temp/authors-per-year.csv
authorremains = $temp/authorremains.csv
authorremains-top = $temp/authorremains.csv
bugbounty = $temp/bugbounty-over-time.csv
bugbounty-amounts = $temp/bugbounty-amounts.csv
bugfix-frequency = $temp/bugfix-frequency.csv
c-vulns = $output/c-vulns-over-time.csv
c-reports = $output/c-vulns-reports.csv
ci-jobs = $temp/CI.csv
ci-platforms = $temp/CI-platforms.csv
ci-services = $temp/CI.csv
cmdline-options-over-time = $temp/cmdline-options-over-time.csv
comments = $temp/comments.csv
commits-per-month = $temp/commits-per-month.csv
commits-per-year = $temp/commits-per-year.csv
commits = $temp/commits-over-time.csv
contribs-release = $temp/contributors-per-release.csv
contrib-tail = $temp/contrib-tail.csv
contributors = $temp/contributors-over-time.csv
coreteam-per-year = $temp/coreteam-per-year.csv
cve-time = $temp/cve-age.csv
daniel-commits = $temp/daniel-commit-share.csv
daniel-vs-rest = $temp/daniel-vs-rest.csv
days-per-release = $temp/days-per-release.csv
deltaloc = $temp/lines-per-month.csv
density = $temp/remains-per-kloc.csv
docs = $temp/docs-over-time.csv
examples = $temp/examples-over-time.csv
files = $temp/files-over-time.csv
filesize = $temp/filesize-over-time.csv
firsttimers = $temp/firsttimers.csv
fixtime = $temp/cve-fixtime.csv
func-calls = $output/cpy-over-time.csv
github-age = $temp/gh-age.csv
github-fixes = $temp/gh-fixes.csv
github-monthly = $temp/gh-monthly.csv
github-open = $temp/gh-open.csv
high-vuln = $output/high-reports.csv
http-versions = $temp/http-over-time.csv
lines = $temp/lines-person.csv
lines-per-author = $temp/lines-per-author.csv
lines-per-docs = $temp/lines-per-docs.csv
lines-per-test = $temp/lines-per-test.csv
loc = $temp/lines-over-time.csv
mail = $temp/mail.csv
manpages = $temp/manpages-over-time.csv
protocols = $temp/protocols-over-time.csv
releases = $temp/release-number.csv
releases-per-year = $temp/releases-per-year.csv
setopts = $temp/setopts-over-time.csv
sev-per-year = $output/sev-per-year.csv
symbols = $temp/symbols-over-time.csv
tests = $temp/tests-over-time.csv
third-parties = $temp/3rdparty-over-time.csv
backends = $temp/tls-over-time.csv
todo = $temp/todo-over-time.csv
vulns-per-year = $temp/vulns-per-year.csv
vulns-plot = $temp/vulns-over-time.csv
vulns-releases = $temp/vulns-releases.csv
vulns-per-kloc = $temp/knownvulns-per-line.csv
EOF

# make the dir world readable
chmod 755 $output
