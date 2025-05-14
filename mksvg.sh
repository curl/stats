#!bin/sh

# Uncomment to debug this script:
set -x
#set -e

# custom dir for the web root directory
webroot=$1

# store the CSV intermediate files here
temp=tmp
# store the SVG output here
output=`mktemp -d svg-XXXXXX`

generate_csv () {
    perl stats/$1.pl $2 > $temp/$1.csv
}

generate_plot () {
    gnuplot -c stats/$1.plot > $output/$1.svg
}

generate_csv date-of-year
gnuplot -c stats/date-of-year.plot > $output/date-of-year.svg

generate_csv month-of-year
gnuplot -c stats/month-of-year.plot > $output/month-of-year.svg

generate_csv weekday-of-year
gnuplot -c stats/weekday-of-year.plot > $output/weekday-of-year.svg

generate_csv contrib-tail
gnuplot -c stats/contrib-tail.plot > $output/contrib-tail.svg

generate_csv mail
gnuplot -c stats/mail.plot > $output/mail.svg

perl stats/github-json.pl > $temp/github.csv
generate_csv gh-monthly $temp/github.csv
gnuplot -c stats/gh-monthly.plot > $output/gh-monthly.svg

generate_csv gh-open $temp/github.csv
gnuplot -c stats/gh-open.plot > $output/gh-open.svg

generate_csv gh-age $temp/github.csv
gnuplot -c stats/gh-age.plot > $output/gh-age.svg

generate_csv gh-fixes $temp/github.csv
gnuplot -c stats/gh-fixes.plot > $output/gh-fixes.svg

generate_csv files-over-time
gnuplot -c stats/files-over-time.plot > $output/files-over-time.svg

generate_csv bugfix-frequency $webroot
gnuplot -c stats/bugfix-frequency.plot > $output/bugfix-frequency.svg

generate_csv API-calls-over-time
gnuplot -c stats/API-calls-over-time.plot > $output/API-calls-over-time.svg

generate_csv protocols-over-time
gnuplot -c stats/protocols-over-time.plot > $output/protocols-over-time.svg

generate_csv tls-over-time
generate_csv ssh-over-time
generate_csv h1-over-time
generate_csv h2-over-time
generate_csv h3-over-time
generate_csv idn-over-time
generate_csv resolver-over-time
gnuplot -c stats/backends-over-time.plot > $output/backends-over-time.svg

generate_csv 3rdparty-over-time
gnuplot -c stats/3rdparty-over-time.plot > $output/3rdparty-over-time.svg

generate_csv http-over-time
gnuplot -c stats/http-over-time.plot > $output/http-over-time.svg

generate_csv daniel-vs-rest
gnuplot -c stats/daniel-vs-rest.plot > $output/daniel-vs-rest.svg

generate_csv daniel-commit-share
gnuplot -c stats/daniel-commit-share.plot > $output/daniel-commit-share.svg

generate_csv authors-per-year
gnuplot -c stats/authors-per-year.plot > $output/authors-per-year.svg

generate_csv authors-active
gnuplot -c stats/authors-active.plot > $output/authors-active.svg

generate_csv commits-per-year
gnuplot -c stats/commits-per-year.plot > $output/commits-per-year.svg

generate_csv commits-over-time
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

generate_csv comments
gnuplot -c stats/comments.plot > $output/comments.svg

generate_csv filesize-over-time
gnuplot -c stats/filesize-over-time.plot > $output/filesize-over-time.svg

perl stats/setopts-over-time.pl | cut '-d;' -f2- > $temp/setopts-over-time.csv
gnuplot -c stats/setopts-over-time.plot > $output/setopts-over-time.svg

perl stats/days-per-release.pl $webroot > $temp/days-per-release.csv
gnuplot -c stats/days-per-release.plot > $output/days-per-release.svg

generate_csv cmdline-options-over-time
gnuplot -c stats/cmdline-options-over-time.plot > $output/cmdline-options-over-time.svg

perl stats/contributors-over-time.pl | cut '-d;' -f2- > $temp/contributors-over-time.csv
gnuplot -c stats/contributors-over-time.plot > $output/contributors-over-time.svg

generate_csv authors
gnuplot -c stats/authors.plot > $output/authors.svg

generate_csv authorremains
gnuplot -c stats/authorremains.plot > $output/authorremains.svg
gnuplot -c stats/authorremains-top.plot > $output/authorremains-top.svg

generate_csv todo-over-time
gnuplot -c stats/todo-over-time.plot > $output/todo-over-time.svg

generate_csv symbols-over-time
gnuplot -c stats/symbols-over-time.plot > $output/symbols-over-time.svg

generate_csv authors-per-month
gnuplot -c stats/authors-per-month.plot > $output/authors-per-month.svg

generate_csv firsttimers
gnuplot -c stats/firsttimers.plot > $output/firsttimers.svg

perl stats/CI-jobs-over-time.pl | cut '-d;' -f2-  > $temp/CI.csv
gnuplot -c stats/CI-jobs-over-time.plot > $output/CI-jobs-over-time.svg
gnuplot -c stats/CI-services.plot > $output/CI-services.svg

generate_csv CI-platforms
gnuplot -c stats/CI-platforms.plot > $output/CI-platforms.svg

generate_csv commits-per-month
gnuplot -c stats/commits-per-month.plot > $output/commits-per-month.svg

generate_csv docs-over-time
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

generate_csv lines-per-month
gnuplot -c stats/lines-per-month.plot > $output/lines-per-month.svg

generate_csv tests-over-time
gnuplot -c stats/tests-over-time.plot > $output/tests-over-time.svg

generate_csv manpages-over-time
gnuplot -c stats/manpages-over-time.plot > $output/manpages-over-time.svg

generate_csv examples-over-time
gnuplot -c stats/examples-over-time.plot > $output/examples-over-time.svg

perl stats/bugbounty-over-time.pl $webroot > $temp/bugbounty-over-time.csv
gnuplot -c stats/bugbounty-over-time.plot > $output/bugbounty-over-time.svg

perl stats/bugbounty-amounts.pl $webroot > $temp/bugbounty-amounts.csv
gnuplot -c stats/bugbounty-amounts.plot > $output/bugbounty-amounts.svg

generate_csv contributors-per-release
gnuplot -c stats/contributors-per-release.plot > $output/contributors-per-release.svg

generate_csv lines-person
gnuplot -c stats/lines-person.plot > $output/lines-person.svg

perl stats/release-number.pl $webroot > $temp/release-number.csv
gnuplot -c stats/release-number.plot > $output/release-number.svg

perl stats/releases-per-year.pl $webroot > $temp/releases-per-year.csv
gnuplot -c stats/releases-per-year.plot > $output/releases-per-year.svg

generate_csv cpy-over-time
gnuplot -c stats/cpy-over-time.plot > $output/cpy-over-time.svg

generate_csv strncpy-over-time
gnuplot -c stats/strncpy-over-time.plot > $output/strncpy-over-time.svg

generate_csv sscanf-over-time
gnuplot -c stats/sscanf-over-time.plot > $output/sscanf-over-time.svg

generate_csv complexity
gnuplot -c stats/complexity.plot > $output/complexity.svg
gnuplot -c stats/funclen.plot > $output/funclen.svg

generate_csv codeage
gnuplot -c stats/codeage.plot > $output/codeage.svg

perl stats/top-cwe.pl $webroot > $temp/top-cwe.csv
gnuplot -c stats/top-cwe.plot > $output/top-cwe.svg

generate_csv testinfra-over-time
gnuplot -c stats/testinfra-over-time.plot > $output/testinfra-over-time.svg

perl stats/plotdivision.pl $temp/testinfra-over-time.csv $temp/lines-over-time.csv 0:1 0:1 1000 > $temp/testinfra-per-line.csv
gnuplot -c stats/testinfra-per-line.plot > $output/testinfra-per-line.svg

perl stats/plotdivision.pl $temp/testinfra-over-time.csv $temp/tests-over-time.csv 0:1 1:2 > $temp/testinfra-per-test.csv
gnuplot -c stats/testinfra-per-test.plot > $output/testinfra-per-test.svg

# Added LOC per LOC still present
generate_csv addedcode
perl stats/plotdivision.pl $temp/addedcode.csv $temp/lines-over-time.csv  0:1 0:1 > $temp/added-per-line.csv
gnuplot -c stats/added-per-line.plot > $output/added-per-line.svg

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

# top-40 authors with production code remaining in master
generate_csv top-remains
gnuplot -c stats/top-remains.plot > $output/top-remains.svg

# CVE severity pie chart
perl stats/cve-pie-chart.pl $webroot > $temp/cve-pie-chart.csv
gnuplot -c stats/cve-pie-chart.plot > $output/cve-pie-chart.svg

cat >stats.list <<EOF
50-percent = $output/50-percent.svg
60-percent = $output/60-percent.svg
70-percent = $output/70-percent.svg
80-percent = $output/80-percent.svg
90-percent = $output/90-percent.svg
95-percent = $output/95-percent.svg
added-per-line = $output/added-per-line.svg
api-calls = $output/API-calls-over-time.svg
authorremains = $output/authorremains.svg
authorremains-top = $output/authorremains-top.svg
authors = $output/authors.svg
authors-active = $output/authors-active.svg
authors-per-month = $output/authors-per-month.svg
authors-per-year = $output/authors-per-year.svg
backends = $output/backends-over-time.svg
bugbounty = $output/bugbounty-over-time.svg
bugbounty-amounts = $output/bugbounty-amounts.svg
bugfix-frequency = $output/bugfix-frequency.svg
c-reports = $output/c-reports.svg
c-vulns = $output/c-vulns.svg
ci-jobs = $output/CI-jobs-over-time.svg
ci-platforms = $output/CI-platforms.svg
ci-services = $output/CI-services.svg
cmdline-options-over-time = $output/cmdline-options-over-time.svg
codeage = $output/codeage.svg
comments = $output/comments.svg
commits = $output/commits-over-time.svg
commits-per-month = $output/commits-per-month.svg
commits-per-year = $output/commits-per-year.svg
complexity = $output/complexity.svg
contrib-tail = $output/contrib-tail.svg
contribs-release = $output/contributors-per-release.svg
contributors = $output/contributors-over-time.svg
coreteam-per-year = $output/coreteam-per-year.svg
cve-pie = $output/cve-pie-chart.svg
cve-time = $output/cve-age.svg
cwe-top = $output/top-cwe.svg
daily-commits = $output/date-of-year.svg
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
funclen = $output/funclen.svg
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
monthly-commits = $output/month-of-year.svg
protocols = $output/protocols-over-time.svg
releases = $output/release-number.svg
releases-per-year = $output/releases-per-year.svg
setopts = $output/setopts-over-time.svg
sev-per-year = $output/sev-per-year.svg
strncpy = $output/strncpy-over-time.svg
sscanf = $output/sscanf-over-time.svg
symbols = $output/symbols-over-time.svg
testinfra = $output/testinfra-over-time.svg
testinfra-kloc = $output/testinfra-per-line.svg
testinfra-test = $output/testinfra-per-test.svg
tests = $output/tests-over-time.svg
third-parties = $output/3rdparty-over-time.svg
todo = $output/todo-over-time.svg
top40 = $output/top-remains.svg
vulns-per-kloc = $output/knownvulns-per-line.svg
vulns-per-year = $output/vulns-per-year.svg
vulns-plot = $output/vulns-plot.svg
vulns-releases = $output/vulns-releases.svg
weekly-commits = $output/weekday-of-year.svg
EOF

# Use the same names but point to the used CSV/data/input file
cat >stats.data <<EOF
50-percent = $temp/50-percent.csv
60-percent = $temp/60-percent.csv
70-percent = $temp/70-percent.csv
80-percent = $temp/80-percent.csv
90-percent = $temp/90-percent.csv
95-percent = $temp/95-percent.csv
added-per-line = $temp/added-per-line.csv
api-calls = $temp/API-calls-over-time.csv
authorremains = $temp/authorremains.csv
authorremains-top = $temp/authorremains.csv
authors = $temp/authors.csv
authors-active = $temp/authors-active.csv
authors-per-month = $temp/authors-per-month.csv
authors-per-year = $temp/authors-per-year.csv
backends = $temp/tls-over-time.csv
bugbounty = $temp/bugbounty-over-time.csv
bugbounty-amounts = $temp/bugbounty-amounts.csv
bugfix-frequency = $temp/bugfix-frequency.csv
c-reports = $temp/c-vuln-reports.csv
c-vulns = $temp/c-vuln-over-time.csv
ci-jobs = $temp/CI.csv
ci-platforms = $temp/CI-platforms.csv
ci-services = $temp/CI.csv
cmdline-options-over-time = $temp/cmdline-options-over-time.csv
codeage = $temp/codeage.csv
comments = $temp/comments.csv
commits = $temp/commits-over-time.csv
commits-per-month = $temp/commits-per-month.csv
commits-per-year = $temp/commits-per-year.csv
complexity = $temp/complexity.csv
contrib-tail = $temp/contrib-tail.csv
contribs-release = $temp/contributors-per-release.csv
contributors = $temp/contributors-over-time.csv
coreteam-per-year = $temp/coreteam-per-year.csv
cve-pie = $temp/cve-pie-chart.csv
cve-time = $temp/cve-age.csv
cwe-top = $temp/top-cwe.csv
daily-commits = $temp/date-of-year.csv
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
func-calls = $temp/cpy-over-time.csv
funclen = $temp/complexity.csv
github-age = $temp/gh-age.csv
github-fixes = $temp/gh-fixes.csv
github-monthly = $temp/gh-monthly.csv
github-open = $temp/gh-open.csv
high-vuln = $temp/high-vuln-reports.csv
http-versions = $temp/http-over-time.csv
lines = $temp/lines-person.csv
lines-per-author = $temp/lines-per-author.csv
lines-per-docs = $temp/lines-per-docs.csv
lines-per-test = $temp/lines-per-test.csv
loc = $temp/lines-over-time.csv
mail = $temp/mail.csv
manpages = $temp/manpages-over-time.csv
monthly-commits = $temp/month-of-year.csv
protocols = $temp/protocols-over-time.csv
releases = $temp/release-number.csv
releases-per-year = $temp/releases-per-year.csv
setopts = $temp/setopts-over-time.csv
sev-per-year = $temp/sev-per-year.csv
strncpy = $temp/strncpy-over-time.csv
sscanf = $temp/sscanf-over-time.csv
symbols = $temp/symbols-over-time.csv
testinfra = $temp/testinfra-over-time.csv
testinfra-kloc = $temp/testinfra-per-line.csv
testinfra-test = $temp/testinfra-per-test.csv
tests = $temp/tests-over-time.csv
third-parties = $temp/3rdparty-over-time.csv
todo = $temp/todo-over-time.csv
top40 = $temp/top-remains.csv
vulns-per-kloc = $temp/knownvulns-per-line.csv
vulns-per-year = $temp/vulns-per-year.csv
vulns-plot = $temp/vulns-over-time.csv
vulns-releases = $temp/vulns-releases.csv
weekly-commits = $temp/weekday-of-year.csv
EOF

# make the dir world readable
chmod 755 $output
