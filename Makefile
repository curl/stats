#
# This Makefile is intended to be invoked from within the curl git source code
# repositories root directory.
#
# make -f [path]/Makefile

# Where to store collected data. This needs to match the hard-coded
# file name used in the *.plot scripts.
DDIR=tmp

# where to store generated graph images
GDIR=svg

# name of the source directory for the scripts
SDIR=./stats

# website source directory
WDIR=../curl-www

# All graphs with a corresponding CSV
GRFCSV = \
 $(GDIR)/3rdparty-over-time.svg \
 $(GDIR)/50-percent.svg \
 $(GDIR)/512-mb.svg  \
 $(GDIR)/60-percent.svg \
 $(GDIR)/70-percent.svg \
 $(GDIR)/80-percent.svg \
 $(GDIR)/90-percent.svg \
 $(GDIR)/95-percent.svg \
 $(GDIR)/added-per-line.svg \
 $(GDIR)/API-calls-over-time.svg \
 $(GDIR)/atoi-over-time.svg \
 $(GDIR)/authorremains.svg \
 $(GDIR)/authors-active.svg \
 $(GDIR)/authors-per-month.svg \
 $(GDIR)/authors-per-year.svg \
 $(GDIR)/authors.svg \
 $(GDIR)/bugbounty-amounts.svg \
 $(GDIR)/bugbounty-over-time.svg \
 $(GDIR)/bugfix-frequency.svg \
 $(GDIR)/c-vuln-code.svg \
 $(GDIR)/c-vuln-reports.svg \
 $(GDIR)/cmdline-options-over-time.svg \
 $(GDIR)/codeage.svg \
 $(GDIR)/comments.svg \
 $(GDIR)/commits-over-time.svg \
 $(GDIR)/commits-per-month.svg \
 $(GDIR)/commits-per-release.svg \
 $(GDIR)/commits-per-year.svg \
 $(GDIR)/complex-dist.svg \
 $(GDIR)/complexity.svg \
 $(GDIR)/connectdata.svg \
 $(GDIR)/contrib-tail.svg \
 $(GDIR)/contributors-over-time.svg \
 $(GDIR)/contributors-per-release.svg \
 $(GDIR)/coreteam-per-year.svg \
 $(GDIR)/cpy-over-time.svg \
 $(GDIR)/cve-age.svg \
 $(GDIR)/cve-fixtime.svg \
 $(GDIR)/cve-pie-chart.svg \
 $(GDIR)/daniel-commit-share.svg \
 $(GDIR)/daniel-vs-rest.svg \
 $(GDIR)/date-of-year.svg \
 $(GDIR)/days-per-release.svg \
 $(GDIR)/docs-over-time.svg \
 $(GDIR)/easy-handle.svg \
 $(GDIR)/examples-over-time.svg \
 $(GDIR)/files-over-time.svg \
 $(GDIR)/filesize-over-time.svg \
 $(GDIR)/firsttimers.svg \
 $(GDIR)/gh-age.svg \
 $(GDIR)/gh-fixes.svg \
 $(GDIR)/gh-monthly.svg \
 $(GDIR)/gh-open.svg \
 $(GDIR)/graphs.svg \
 $(GDIR)/h1-per-year.svg \
 $(GDIR)/high-vuln-reports.svg \
 $(GDIR)/http-over-time.svg \
 $(GDIR)/ifdef-over-time.svg \
 $(GDIR)/knownvulns-per-line.svg \
 $(GDIR)/line-complex.svg \
 $(GDIR)/lines-over-time.svg \
 $(GDIR)/lines-per-author.svg \
 $(GDIR)/lines-per-docs.svg \
 $(GDIR)/lines-per-month.svg \
 $(GDIR)/lines-per-test.svg \
 $(GDIR)/lines-person.svg \
 $(GDIR)/loc-per-day.svg \
 $(GDIR)/mail.svg \
 $(GDIR)/manpage-lines-per-option.svg \
 $(GDIR)/manpage.svg \
 $(GDIR)/manpages-over-time.svg \
 $(GDIR)/month-of-year.svg \
 $(GDIR)/multi-handle.svg \
 $(GDIR)/project-age.svg \
 $(GDIR)/protocols-over-time.svg \
 $(GDIR)/release-number.svg \
 $(GDIR)/releases-per-year.svg \
 $(GDIR)/remains-per-kloc.svg \
 $(GDIR)/setopts-over-time.svg \
 $(GDIR)/sev-per-year.svg \
 $(GDIR)/severity.svg \
 $(GDIR)/sscanf-over-time.svg \
 $(GDIR)/strcpy-over-time.svg \
 $(GDIR)/strncpy-over-time.svg \
 $(GDIR)/symbols-over-time.svg \
 $(GDIR)/testinfra-over-time.svg \
 $(GDIR)/testinfra-per-line.svg \
 $(GDIR)/testinfra-per-test.svg \
 $(GDIR)/tests-over-time.svg \
 $(GDIR)/todo-over-time.svg \
 $(GDIR)/top-cwe.svg \
 $(GDIR)/top-remains.svg \
 $(GDIR)/vuln-dist-code.svg \
 $(GDIR)/vulns-over-time.svg \
 $(GDIR)/vulns-per-year.svg \
 $(GDIR)/weekday-of-year.svg

# The CSVs for the backend graph
BACKENDCSV= \
 $(DDIR)/tls-over-time.csv \
 $(DDIR)/ssh-over-time.csv \
 $(DDIR)/h1-over-time.csv \
 $(DDIR)/h2-over-time.csv \
 $(DDIR)/h3-over-time.csv \
 $(DDIR)/idn-over-time.csv \
 $(DDIR)/resolver-over-time.csv

# Add "special" CSV files not matching the pattern above
CSV = $(CVSGRF) \
 $(DDIR)/github.csv \
 $(BACKENDCSV)

# Many graph scripts are named as their CSV inputs
GRAPHS=$(GRFCSV) \
 $(GDIR)/backends-over-time.svg \
 $(GDIR)/authorremains-top.svg \
 $(GDIR)/funclen.svg

GNUPLOT=gnuplot -c $(SDIR)/$(basename $(notdir $@)).plot $(DDIR) > $@

GENCSV=perl $(SDIR)/$(basename $(notdir $@)).pl $(WDIR) > $@

NAMES=$(GDIR)/stats.list

all: $(GRAPHS) $(NAMES)

$(GDIR)/graphs.svg: $(DDIR)/graphs.csv $(SDIR)/graphs.plot
	$(GNUPLOT)
$(DDIR)/graphs.csv:
	$(GENCSV)

$(NAMES): $(SDIR)/stats.sh $(SDIR)/Makefile
	$(SDIR)/stats.sh $(GDIR) > $(GDIR)/stats.list

$(GDIR)/ifdef-over-time.svg: $(DDIR)/ifdef-over-time.csv $(DDIR)/ifdef-per-kloc.csv
	$(GNUPLOT)
$(DDIR)/ifdef-over-time.csv:
	$(GENCSV)
$(DDIR)/ifdef-per-kloc.csv: $(DDIR)/ifdef-over-time.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/ifdef-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/atoi-over-time.svg: $(DDIR)/atoi-over-time.csv $(DDIR)/atoi-per-kloc.csv
	$(GNUPLOT)
$(DDIR)/atoi-over-time.csv:
	$(GENCSV)
$(DDIR)/atoi-per-kloc.csv: $(DDIR)/atoi-over-time.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/atoi-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/cve-pie-chart.svg: $(DDIR)/cve-pie-chart.csv
	$(GNUPLOT)
$(DDIR)/cve-pie-chart.csv:
	$(GENCSV)

$(GDIR)/top-remains.svg: $(DDIR)/top-remains.csv
	$(GNUPLOT)
$(DDIR)/top-remains.csv:
	$(GENCSV)

$(GDIR)/remains-per-kloc.svg: $(DDIR)/remains-per-kloc.csv
	$(GNUPLOT)
$(DDIR)/remains-per-kloc.csv: $(DDIR)/authorremains.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/authorremains.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/manpage-lines-per-option.svg: $(DDIR)/manpage-lines-per-option.csv
	$(GNUPLOT)
$(DDIR)/manpage-lines-per-option.csv: $(DDIR)/manpage.csv $(DDIR)/cmdline-options-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/manpage.csv $(DDIR)/cmdline-options-over-time.csv 1:2 0:1 > $@

$(GDIR)/lines-per-author.svg: $(DDIR)/lines-per-author.csv $(DDIR)/lines-per-contributor.csv
	$(GNUPLOT)
$(DDIR)/lines-per-contributor.csv:$(DDIR)/contributors-over-time.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/contributors-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@
$(DDIR)/lines-per-author.csv: $(DDIR)/authors.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/authors.csv $(DDIR)/lines-over-time.csv 0:2 0:1 1000 > $@

$(GDIR)/knownvulns-per-line.svg: $(DDIR)/knownvulns-per-line.csv
	$(GNUPLOT)
$(DDIR)/knownvulns-per-line.csv: $(DDIR)/vulns-releases.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/vulns-releases.csv $(DDIR)/lines-over-time.csv 0:2 0:1 1000 > $@

$(GDIR)/lines-per-test.svg: $(DDIR)/lines-per-test.csv
	$(GNUPLOT)
$(DDIR)/lines-per-test.csv: $(DDIR)/tests-over-time.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/tests-over-time.csv $(DDIR)/lines-over-time.csv 1:2 0:1 1000 > $@

$(GDIR)/lines-per-docs.svg: $(DDIR)/lines-per-docs.csv
	$(GNUPLOT)
$(DDIR)/lines-per-docs.csv: $(DDIR)/docs-over-time.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/docs-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/added-per-line.svg: $(DDIR)/added-per-line.csv
	$(GNUPLOT)
$(DDIR)/addedcode.csv:
	perl stats/addedcode.pl >$@
$(DDIR)/added-per-line.csv: $(DDIR)/addedcode.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/addedcode.csv $(DDIR)/lines-over-time.csv 0:1 0:1 >$@

$(GDIR)/h1-per-year.svg: $(DDIR)/h1-reports.csv
	$(GNUPLOT)
$(DDIR)/h1-reports.csv:
	cp $(SDIR)/h1-reports.md $@

$(GDIR)/testinfra-per-test.svg: $(DDIR)/testinfra-per-test.csv
	$(GNUPLOT)
$(DDIR)/testinfra-per-test.csv: $(DDIR)/testinfra-over-time.csv $(DDIR)/tests-over-time.csv
	perl stats/plotdivision.pl $(DDIR)/testinfra-over-time.csv $(DDIR)/tests-over-time.csv 0:1 1:2 > $@

$(GDIR)/testinfra-per-line.svg: $(DDIR)/testinfra-per-line.csv
	$(GNUPLOT)
$(DDIR)/testinfra-per-line.csv: $(DDIR)/testinfra-over-time.csv $(DDIR)/lines-over-time.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/testinfra-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/loc-per-day.svg: $(DDIR)/loc-per-day.csv
	$(GNUPLOT)
$(DDIR)/loc-per-day.csv: $(DDIR)/lines-over-time.csv $(DDIR)/project-age.csv
	perl $(SDIR)/plotdivision.pl $(DDIR)/lines-over-time.csv $(DDIR)/project-age.csv 0:1 0:1 > $@

$(GDIR)/project-age.svg: $(DDIR)/project-age.csv
	$(GNUPLOT)
$(DDIR)/project-age.csv:
	$(GENCSV)

$(GDIR)/testinfra-over-time.svg: $(DDIR)/testinfra-over-time.csv
	$(GNUPLOT)
$(DDIR)/testinfra-over-time.csv:
	$(GENCSV)

$(GDIR)/top-cwe.svg: $(DDIR)/top-cwe.csv
	$(GNUPLOT)
$(DDIR)/top-cwe.csv:
	$(GENCSV)

$(GDIR)/codeage.svg: $(DDIR)/codeage.csv
	$(GNUPLOT)
$(DDIR)/codeage.csv:
	$(GENCSV)

$(GDIR)/complex-dist.svg: $(DDIR)/complex-dist.csv
	$(GNUPLOT)
$(DDIR)/complex-dist.csv:
	$(GENCSV)

$(GDIR)/line-complex.svg: $(DDIR)/line-complex.csv
	$(GNUPLOT)
$(DDIR)/line-complex.csv:
	$(GENCSV)

$(GDIR)/funclen.svg: $(DDIR)/complexity.csv
	$(GNUPLOT)

$(GDIR)/complexity.svg: $(DDIR)/complexity.csv
	$(GNUPLOT)
$(DDIR)/complexity.csv:
	$(GENCSV)

$(GDIR)/sscanf-over-time.svg: $(DDIR)/sscanf-over-time.csv
	$(GNUPLOT)
$(DDIR)/sscanf-over-time.csv:
	$(GENCSV)

$(GDIR)/strcpy-over-time.svg: $(DDIR)/strcpy-over-time.csv
	$(GNUPLOT)
$(DDIR)/strcpy-over-time.csv:
	$(GENCSV)

$(GDIR)/strncpy-over-time.svg: $(DDIR)/strncpy-over-time.csv
	$(GNUPLOT)
$(DDIR)/strncpy-over-time.csv:
	$(GENCSV)

$(GDIR)/cpy-over-time.svg: $(DDIR)/cpy-over-time.csv
	$(GNUPLOT)
$(DDIR)/cpy-over-time.csv:
	$(GENCSV)

$(GDIR)/releases-per-year.svg: $(DDIR)/releases-per-year.csv
	$(GNUPLOT)
$(DDIR)/releases-per-year.csv:
	$(GENCSV)

$(GDIR)/release-number.svg: $(DDIR)/release-number.csv
	$(GNUPLOT)
$(DDIR)/release-number.csv:
	$(GENCSV)

$(GDIR)/lines-person.svg: $(DDIR)/lines-person.csv
	$(GNUPLOT)
$(DDIR)/lines-person.csv:
	$(GENCSV)

$(GDIR)/contributors-per-release.svg: $(DDIR)/contributors-per-release.csv
	$(GNUPLOT)
$(DDIR)/contributors-per-release.csv:
	$(GENCSV)

$(GDIR)/bugbounty-amounts.svg: $(DDIR)/bugbounty-amounts.csv
	$(GNUPLOT)
$(DDIR)/bugbounty-amounts.csv:
	$(GENCSV)

$(GDIR)/bugbounty-over-time.svg: $(DDIR)/bugbounty-over-time.csv
	$(GNUPLOT)
$(DDIR)/bugbounty-over-time.csv:
	$(GENCSV)

$(GDIR)/examples-over-time.svg: $(DDIR)/examples-over-time.csv
	$(GNUPLOT)
$(DDIR)/examples-over-time.csv:
	$(GENCSV)

$(GDIR)/manpage.svg: $(DDIR)/manpage.csv
	$(GNUPLOT)
$(DDIR)/manpage.csv:
	$(GENCSV)

$(GDIR)/manpages-over-time.svg: $(DDIR)/manpages-over-time.csv
	$(GNUPLOT)
$(DDIR)/manpages-over-time.csv:
	$(GENCSV)

$(GDIR)/tests-over-time.svg: $(DDIR)/tests-over-time.csv
	$(GNUPLOT)
$(DDIR)/tests-over-time.csv:
	$(GENCSV)

$(GDIR)/lines-per-month.svg: $(DDIR)/lines-per-month.csv
	$(GNUPLOT)
$(DDIR)/lines-per-month.csv:
	$(GENCSV)

$(GDIR)/lines-over-time.svg: $(DDIR)/lines-over-time.csv
	$(GNUPLOT)
$(DDIR)/lines-over-time.csv:
	$(GENCSV)

$(GDIR)/severity.svg: $(DDIR)/severity.csv
	$(GNUPLOT)
$(DDIR)/severity.csv:
	$(GENCSV)

$(GDIR)/sev-per-year.svg: $(DDIR)/sev-per-year.csv
	$(GNUPLOT)
$(DDIR)/sev-per-year.csv:
	$(GENCSV)

$(GDIR)/high-vuln-reports.svg: $(DDIR)/high-vuln-reports.csv
	$(GNUPLOT)
$(DDIR)/high-vuln-reports.csv:
	$(GENCSV)

$(GDIR)/c-vuln-reports.svg: $(DDIR)/c-vuln-reports.csv
	$(GNUPLOT)
$(DDIR)/c-vuln-reports.csv:
	$(GENCSV)

$(GDIR)/c-vuln-code.svg: $(DDIR)/c-vuln-code.csv
	$(GNUPLOT)
$(DDIR)/c-vuln-code.csv:
	$(GENCSV)

$(GDIR)/vulns-per-year.svg: $(DDIR)/vulns-per-year.csv
	$(GNUPLOT)
$(DDIR)/vulns-per-year.csv:
	perl $(SDIR)/vulns-per-year.pl $(WDIR) $(DDIR)/cve-intro.csv > $@

$(GDIR)/vulns-over-time.svg: $(DDIR)/vulns-over-time.csv $(DDIR)/cve-intro.csv
	$(GNUPLOT)
$(DDIR)/vulns-over-time.csv:
	$(GENCSV)
$(DDIR)/cve-intro.csv:
	$(GENCSV)

$(GDIR)/cve-fixtime.svg: $(DDIR)/cve-fixtime.csv
	$(GNUPLOT)
$(DDIR)/cve-fixtime.csv:
	$(GENCSV)

$(GDIR)/cve-age.svg: $(DDIR)/cve-age.csv
	$(GNUPLOT)
$(DDIR)/cve-age.csv:
	$(GENCSV)

$(GDIR)/vuln-dist-code.svg: $(DDIR)/vuln-dist-code.csv
	$(GNUPLOT)
$(DDIR)/vuln-dist-code.csv:
	$(GENCSV)

$(GDIR)/docs-over-time.svg: $(DDIR)/docs-over-time.csv
	$(GNUPLOT)
$(DDIR)/docs-over-time.csv:
	$(GENCSV)

$(GDIR)/commits-per-month.svg: $(DDIR)/commits-per-month.csv
	$(GNUPLOT)
$(DDIR)/commits-per-month.csv:
	$(GENCSV)

$(GDIR)/firsttimers.svg: $(DDIR)/firsttimers.csv
	$(GNUPLOT)
$(DDIR)/firsttimers.csv:
	$(GENCSV)

$(GDIR)/authors-per-month.svg: $(DDIR)/authors-per-month.csv
	$(GNUPLOT)
$(DDIR)/authors-per-month.csv:
	$(GENCSV)

$(GDIR)/symbols-over-time.svg: $(DDIR)/symbols-over-time.csv
	$(GNUPLOT)
$(DDIR)/symbols-over-time.csv:
	$(GENCSV)

$(GDIR)/todo-over-time.svg: $(DDIR)/todo-over-time.csv
	$(GNUPLOT)
$(DDIR)/todo-over-time.csv:
	$(GENCSV)

$(GDIR)/authorremains-top.svg: $(DDIR)/authorremains.csv
	$(GNUPLOT)

$(GDIR)/authorremains.svg: $(DDIR)/authorremains.csv
	$(GNUPLOT)
$(DDIR)/authorremains.csv:
	$(GENCSV)

$(GDIR)/authors.svg: $(DDIR)/authors.csv
	$(GNUPLOT)
$(DDIR)/authors.csv:
	$(GENCSV)

$(GDIR)/contributors-over-time.svg: $(DDIR)/contributors-over-time.csv
	$(GNUPLOT)
$(DDIR)/contributors-over-time.csv:
	perl $(SDIR)/contributors-over-time.pl | cut '-d;' -f2- > $@

$(GDIR)/cmdline-options-over-time.svg: $(DDIR)/cmdline-options-over-time.csv
	$(GNUPLOT)
$(DDIR)/cmdline-options-over-time.csv:
	$(GENCSV)

$(GDIR)/commits-per-release.svg: $(DDIR)/commits-per-release.csv
	$(GNUPLOT)
$(DDIR)/commits-per-release.csv:
	$(GENCSV)

$(GDIR)/days-per-release.svg: $(DDIR)/days-per-release.csv
	$(GNUPLOT)
$(DDIR)/days-per-release.csv:
	$(GENCSV)

$(GDIR)/setopts-over-time.svg: $(DDIR)/setopts-over-time.csv
	$(GNUPLOT)
$(DDIR)/setopts-over-time.csv:
	perl $(SDIR)/setopts-over-time.pl | cut '-d;' -f2- >$@

$(GDIR)/filesize-over-time.svg: $(DDIR)/filesize-over-time.csv
	$(GNUPLOT)
$(DDIR)/filesize-over-time.csv:
	$(GENCSV)

$(GDIR)/comments.svg: $(DDIR)/comments.csv
	$(GNUPLOT)
$(DDIR)/comments.csv:
	$(GENCSV)

$(GDIR)/50-percent.svg: $(DDIR)/50-percent.csv
	$(GNUPLOT)
$(DDIR)/50-percent.csv:
	perl $(SDIR)/80-percent.pl 50 > $@

$(GDIR)/60-percent.svg: $(DDIR)/60-percent.csv
	$(GNUPLOT)
$(DDIR)/60-percent.csv:
	perl $(SDIR)/80-percent.pl 60 > $@

$(GDIR)/70-percent.svg: $(DDIR)/70-percent.csv
	$(GNUPLOT)
$(DDIR)/70-percent.csv:
	perl $(SDIR)/80-percent.pl 70 > $@

$(GDIR)/80-percent.svg: $(DDIR)/80-percent.csv
	$(GNUPLOT)
$(DDIR)/80-percent.csv:
	perl $(SDIR)/80-percent.pl 80 > $@

$(GDIR)/90-percent.svg: $(DDIR)/90-percent.csv
	$(GNUPLOT)
$(DDIR)/90-percent.csv:
	perl $(SDIR)/80-percent.pl 90 > $@

$(GDIR)/95-percent.svg: $(DDIR)/95-percent.csv
	$(GNUPLOT)
$(DDIR)/95-percent.csv:
	perl $(SDIR)/80-percent.pl 95 > $@

$(GDIR)/coreteam-per-year.svg: $(DDIR)/coreteam-per-year.csv $(DDIR)/coreteam-percent.csv
	$(GNUPLOT)
$(DDIR)/coreteam-per-year.csv:
	perl $(SDIR)/coreteam-over-time.pl | grep "^[12]" | tr -d '(' | awk '{ print $$1"-01-01;"$$2; }' >$@
$(DDIR)/coreteam-percent.csv:
	perl $(SDIR)/coreteam-over-time.pl | grep '^[12]' | cut -d" " -f 1,5 | tr -d '%' | awk '{ if($$2 > 0) {print $$1"-01-01;"$$2; }}' > $@

$(GDIR)/commits-over-time.svg: $(DDIR)/commits-over-time.csv
	$(GNUPLOT)
$(DDIR)/commits-over-time.csv:
	$(GENCSV)

$(GDIR)/commits-per-year.svg: $(DDIR)/commits-per-year.csv
	$(GNUPLOT)
$(DDIR)/commits-per-year.csv:
	$(GENCSV)

$(GDIR)/authors-active.svg: $(DDIR)/authors-active.csv
	$(GNUPLOT)
$(DDIR)/authors-active.csv:
	$(GENCSV)

$(GDIR)/authors-per-year.svg: $(DDIR)/authors-per-year.csv
	$(GNUPLOT)
$(DDIR)/authors-per-year.csv:
	$(GENCSV)

$(GDIR)/daniel-commit-share.svg: $(DDIR)/daniel-commit-share.csv
	$(GNUPLOT)
$(DDIR)/daniel-commit-share.csv:
	$(GENCSV)

$(GDIR)/daniel-vs-rest.svg: $(DDIR)/daniel-vs-rest.csv
	$(GNUPLOT)
$(DDIR)/daniel-vs-rest.csv:
	$(GENCSV)

$(GDIR)/http-over-time.svg: $(DDIR)/http-over-time.csv
	$(GNUPLOT)
$(DDIR)/http-over-time.csv:
	$(GENCSV)

$(GDIR)/3rdparty-over-time.svg: $(DDIR)/3rdparty-over-time.csv
	$(GNUPLOT)
$(DDIR)/3rdparty-over-time.csv:
	$(GENCSV)

$(GDIR)/backends-over-time.svg: $(BACKENDCSV)
	$(GNUPLOT)
$(DDIR)/tls-over-time.csv:
	$(GENCSV)
$(DDIR)/ssh-over-time.csv:
	$(GENCSV)
$(DDIR)/h1-over-time.csv:
	$(GENCSV)
$(DDIR)/h2-over-time.csv:
	$(GENCSV)
$(DDIR)/h3-over-time.csv:
	$(GENCSV)
$(DDIR)/idn-over-time.csv:
	$(GENCSV)
$(DDIR)/resolver-over-time.csv:
	$(GENCSV)

$(GDIR)/gh-fixes.svg: $(DDIR)/gh-fixes.csv
	$(GNUPLOT)
$(DDIR)/gh-fixes.csv: $(DDIR)/github.csv
	perl stats/gh-fixes.pl $(DDIR)/github.csv > $@

$(GDIR)/gh-age.svg: $(DDIR)/gh-age.csv
	$(GNUPLOT)
$(DDIR)/gh-age.csv: $(DDIR)/github.csv
	perl stats/gh-age.pl $(DDIR)/github.csv > $@

$(GDIR)/gh-monthly.svg: $(DDIR)/gh-monthly.csv
	$(GNUPLOT)
$(DDIR)/gh-monthly.csv: $(DDIR)/github.csv
	perl stats/gh-monthly.pl $(DDIR)/github.csv > $@

$(GDIR)/gh-open.svg: $(DDIR)/gh-open.csv
	$(GNUPLOT)
$(DDIR)/gh-open.csv: $(DDIR)/github.csv
	perl stats/gh-open.pl $(DDIR)/github.csv > $@

$(DDIR)/github.csv:
	perl $(SDIR)/github-json.pl > $@

$(GDIR)/protocols-over-time.svg: $(DDIR)/protocols-over-time.csv
	$(GNUPLOT)
$(DDIR)/protocols-over-time.csv:
	$(GENCSV)

$(GDIR)/API-calls-over-time.svg: $(DDIR)/API-calls-over-time.csv
	$(GNUPLOT)
$(DDIR)/API-calls-over-time.csv:
	$(GENCSV)

$(GDIR)/bugfix-frequency.svg: $(DDIR)/bugfix-frequency.csv
	$(GNUPLOT)
$(DDIR)/bugfix-frequency.csv:
	$(GENCSV)

$(GDIR)/files-over-time.svg: $(DDIR)/files-over-time.csv
	$(GNUPLOT)
$(DDIR)/files-over-time.csv:
	$(GENCSV)

$(GDIR)/mail.svg: $(DDIR)/mail.csv
	$(GNUPLOT)
$(DDIR)/mail.csv:
	$(GENCSV)

$(GDIR)/contrib-tail.svg: $(DDIR)/contrib-tail.csv
	$(GNUPLOT)
$(DDIR)/contrib-tail.csv:
	$(GENCSV)

$(GDIR)/weekday-of-year.svg: $(DDIR)/weekday-of-year.csv
	$(GNUPLOT)
$(DDIR)/weekday-of-year.csv:
	$(GENCSV)

$(GDIR)/date-of-year.svg: $(DDIR)/date-of-year.csv
	$(GNUPLOT)
$(DDIR)/date-of-year.csv:
	$(GENCSV)

$(GDIR)/month-of-year.svg: $(DDIR)/month-of-year.csv
	$(GNUPLOT)
$(DDIR)/month-of-year.csv:
	$(GENCSV)

$(GDIR)/512-mb.svg: $(DDIR)/512-mb.csv
	$(GNUPLOT)
$(DDIR)/512-mb.csv:
	cp $(SDIR)/512-mb.csv $@

$(GDIR)/multi-handle.svg: $(DDIR)/multi-handle.csv
	$(GNUPLOT)
$(DDIR)/multi-handle.csv:
	cp $(SDIR)/multi-handle.csv $@

$(GDIR)/easy-handle.svg: $(DDIR)/easy-handle.csv
	$(GNUPLOT)
$(DDIR)/easy-handle.csv:
	cp $(SDIR)/easy-handle.csv $@

$(GDIR)/connectdata.svg: $(DDIR)/connectdata.csv
	$(GNUPLOT)
$(DDIR)/connectdata.csv:
	cp $(SDIR)/connectdata.csv $@

clean:
	rm -f $(CSV) $(GRAPHS) $(NAMES)
