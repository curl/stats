#!bin/sh

# Uncomment to debug this script:
set -x
set -e

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
    gnuplot -e "logo='doc/images/openssl.png'" -c stats/$1.plot > $output/$1.svg
}

generate_chart () {
    generate_csv $1 $2
    generate_plot $1
}

generate_chart date-of-year 

generate_chart month-of-year 

generate_chart weekday-of-year 

generate_chart contrib-tail 

generate_chart mail 

perl stats/github-json.pl > $temp/github.csv
generate_chart gh-monthly $temp/github.csv

generate_chart gh-open $temp/github.csv

generate_chart gh-age $temp/github.csv

generate_chart gh-fixes $temp/github.csv

perl stats/discussion-json.pl > $temp/discussion.csv
generate_chart discussions-monthly $temp/discussion.csv

generate_chart files-over-time 

generate_chart bugfix-frequency $webroot

generate_chart API-calls-over-time 

generate_chart protocols-over-time 

generate_csv tls-over-time
generate_csv ssh-over-time
generate_csv h1-over-time
generate_csv h2-over-time
generate_csv h3-over-time
generate_csv idn-over-time
generate_csv  resolver-over-time
generate_plot backends-over-time

generate_chart 3rdparty-over-time 

generate_chart http-over-time 

generate_chart daniel-vs-rest 

generate_chart daniel-commit-share 

generate_chart authors-per-year 

generate_chart authors-active 

generate_chart commits-per-year 

generate_chart commits-over-time 

perl stats/coreteam-over-time.pl | grep "^[12]" | tr -d '(' | awk '{ print $1"-01-01;"$2; }' > $temp/coreteam-per-year.csv
perl stats/coreteam-over-time.pl | grep '^[12]' | cut -d" " -f 1,5 | tr -d '%' | awk '{ if($2 > 0) {print $1"-01-01;"$2; }}' > $temp/coreteam-percent.csv
generate_plot coreteam-per-year


perl stats/80-percent.pl 90 > $temp/90-percent.csv
generate_csv 80-percent 80
perl stats/80-percent.pl 70 > $temp/70-percent.csv
perl stats/80-percent.pl 60 > $temp/60-percent.csv
perl stats/80-percent.pl 50 > $temp/50-percent.csv
generate_plot 95-percent
generate_plot 90-percent
generate_plot 80-percent
generate_plot 70-percent
generate_plot 60-percent
generate_plot 50-percent

generate_chart comments 

generate_chart filesize-over-time 

perl stats/setopts-over-time.pl | cut '-d;' -f2- > $temp/setopts-over-time.csv
generate_plot setopts-over-time

generate_chart days-per-release $webroot

generate_chart cmdline-options-over-time 

perl stats/contributors-over-time.pl | cut '-d;' -f2- > $temp/contributors-over-time.csv
generate_plot contributors-over-time

generate_chart authors 

generate_chart authorremains 
generate_plot authorremains-top

generate_chart todo-over-time 

generate_chart symbols-over-time 

generate_chart authors-per-month 

generate_chart firsttimers 

perl stats/CI-jobs-over-time.pl | cut '-d;' -f2-  > $temp/CI.csv
generate_plot CI-jobs-over-time
generate_plot CI-services

generate_chart CI-platforms 

generate_chart commits-per-month 

generate_chart docs-over-time 

generate_chart vulns-releases $webroot

generate_chart cve-age $webroot

generate_chart cve-fixtime $webroot

generate_csv cve-intro $webroot
generate_csv vulns-over-time $webroot
gnuplot -c stats/vulns-over-time.plot > $output/vulns-plot.svg

generate_chart vulns-per-year $webroot $temp/cve-intro.csv

generate_csv c-vuln-over-time $webroot
gnuplot -c stats/c-vuln-over-time.plot > $output/c-vulns.svg

generate_csv c-vuln-reports $webroot
gnuplot -c stats/c-vuln-reports.plot > $output/c-reports.svg

generate_csv high-vuln-reports $webroot
gnuplot -c stats/high-vuln-reports.plot > $output/high-reports.svg

generate_chart sev-per-year $webroot

perl stats/lines-over-time.pl > $temp/lines-over-time.csv
generate_plot lines-over-time

generate_chart lines-per-month 

generate_chart tests-over-time 

generate_chart manpages-over-time 

generate_chart examples-over-time 

generate_chart bugbounty-over-time $webroot

generate_chart bugbounty-amounts $webroot

generate_chart contributors-per-release 

generate_chart lines-person 

generate_chart release-number $webroot

generate_chart releases-per-year $webroot

generate_chart cpy-over-time 

generate_chart strncpy-over-time 

generate_chart sscanf-over-time 

generate_chart complexity 
generate_plot funclen

generate_chart codeage 

generate_chart top-cwe $webroot

generate_chart testinfra-over-time 

perl stats/plotdivision.pl $temp/testinfra-over-time.csv $temp/lines-over-time.csv 0:1 0:1 1000 > $temp/testinfra-per-line.csv
generate_plot testinfra-per-line

perl stats/plotdivision.pl $temp/testinfra-over-time.csv $temp/tests-over-time.csv 0:1 1:2 > $temp/testinfra-per-test.csv
generate_plot testinfra-per-test

# Added LOC per LOC still present
generate_csv addedcode
perl stats/plotdivision.pl $temp/addedcode.csv $temp/lines-over-time.csv  0:1 0:1 > $temp/added-per-line.csv
generate_plot added-per-line

# lines of docs per KLOC
#
# uses already generated CSV files to make a new one
perl stats/plotdivision.pl $temp/docs-over-time.csv $temp/lines-over-time.csv 0:1 0:1 1000 > $temp/lines-per-docs.csv
generate_plot lines-per-docs

# number of tests per KLOC

perl stats/plotdivision.pl $temp/tests-over-time.csv $temp/lines-over-time.csv  1:2 0:1 1000 > $temp/lines-per-test.csv
generate_plot lines-per-test

# known vulnerability per KLOC

perl stats/plotdivision.pl $temp/vulns-releases.csv $temp/lines-over-time.csv 0:2 0:1 1000 > $temp/knownvulns-per-line.csv
generate_plot knownvulns-per-line

# authors and contributors per KLOC

perl stats/plotdivision.pl $temp/authors.csv $temp/lines-over-time.csv 0:2 0:1 1000 > $temp/lines-per-author.csv
perl stats/plotdivision.pl $temp/contributors-over-time.csv $temp/lines-over-time.csv 0:1 0:1 1000 > $temp/lines-per-contributor.csv
generate_plot lines-per-author

# remaining authors per KLOC

perl stats/plotdivision.pl $temp/authorremains.csv $temp/lines-over-time.csv 0:1 0:1 1000 > $temp/remains-per-kloc.csv
generate_plot remains-per-kloc

# top-40 authors with production code remaining in master
generate_chart top-remains 

# CVE severity pie chart
generate_chart cve-pie-chart $webroot

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
