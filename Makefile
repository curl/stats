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
 $(GDIR)/commit-sizes.svg \
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
 $(GDIR)/curlmopts-over-time.svg \
 $(GDIR)/cve-age.svg \
 $(GDIR)/cve-fixtime.svg \
 $(GDIR)/cve-oldest.svg \
 $(GDIR)/cve-pie-chart.svg \
 $(GDIR)/cvuln-per-year.svg \
 $(GDIR)/cvuln-per-year-intro.svg \
 $(GDIR)/daniel-commit-share.svg \
 $(GDIR)/daniel-vs-rest.svg \
 $(GDIR)/date-of-year.svg \
 $(GDIR)/days-per-cmdline-option.svg \
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
 $(GDIR)/heatmap-releasedays.svg \
 $(GDIR)/heatmap-weekhour.svg \
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
 $(GDIR)/timezones.svg \
 $(GDIR)/todo-over-time.svg \
 $(GDIR)/top-cwe.svg \
 $(GDIR)/top-remains.svg \
 $(GDIR)/vuln-dist-code.svg \
 $(GDIR)/vulns-over-time.svg \
 $(GDIR)/vulns-per-year.svg \
 $(GDIR)/vulns-releases.svg \
 $(GDIR)/weekday-of-year.svg \
 $(GDIR)/words-over-time.svg

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

INCLUDE=$(SDIR)/logo.include

GNUPLOT=gnuplot -c $(SDIR)/$(basename $(notdir $@)).plot $(DDIR) > $@

GENCSV=perl $(SDIR)/$(basename $(notdir $@)).pl $(WDIR) > $@

NAMES=$(GDIR)/all.txt

all: $(GRAPHS) $(NAMES)

$(GDIR)/words-over-time.svg: $(INCLUDE) $(SDIR)/words-over-time.plot $(DDIR)/words-over-time.csv
	$(GNUPLOT)
$(DDIR)/words-over-time.csv: $(SDIR)/words-over-time.pl
	$(GENCSV)

$(GDIR)/heatmap-weekhour.svg: $(INCLUDE) $(SDIR)/heatmap-weekhour.plot $(DDIR)/heatmap-weekhour.csv
	$(GNUPLOT)
$(DDIR)/heatmap-weekhour.csv: $(SDIR)/heatmap-weekhour.pl
	$(GENCSV)

$(GDIR)/days-per-cmdline-option.svg: $(INCLUDE) $(SDIR)/days-per-cmdline-option.plot $(DDIR)/days-per-cmdline-option.csv
	$(GNUPLOT)
$(DDIR)/days-per-cmdline-option.csv: $(DDIR)/cmdline-options-over-time.csv $(DDIR)/project-age.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/project-age.csv $(DDIR)/cmdline-options-over-time.csv 0:1 0:1 > $@

$(GDIR)/heatmap-releasedays.svg: $(INCLUDE) $(SDIR)/heatmap-releasedays.plot $(DDIR)/heatmap-releasedays.csv
	$(GNUPLOT)
$(DDIR)/heatmap-releasedays.csv: $(SDIR)/heatmap-releasedays.pl
	$(GENCSV)

$(GDIR)/curlmopts-over-time.svg: $(INCLUDE) $(SDIR)/curlmopts-over-time.plot $(DDIR)/curlmopts-over-time.csv
	$(GNUPLOT)

$(DDIR)/curlmopts-over-time.csv: $(SDIR)/curlmopts-over-time.pl
	$(GENCSV)

$(GDIR)/cve-oldest.svg: $(INCLUDE) $(SDIR)/cve-oldest.plot $(DDIR)/cve-oldest.csv
	$(GNUPLOT)
$(DDIR)/cve-oldest.csv: $(SDIR)/cve-oldest.pl
	$(GENCSV)

$(GDIR)/timezones.svg: $(INCLUDE) $(SDIR)/timezones.plot $(DDIR)/timezones.csv
	$(GNUPLOT)
$(DDIR)/timezones.csv: $(SDIR)/timezones.pl
	$(GENCSV)

$(GDIR)/commit-sizes.svg: $(INCLUDE) $(DDIR)/commit-sizes.csv $(SDIR)/commit-sizes.plot
	$(GNUPLOT)
$(DDIR)/commit-sizes.csv: $(SDIR)/commit-sizes.pl
	$(GENCSV)

$(GDIR)/graphs.svg: $(INCLUDE) $(DDIR)/graphs.csv $(SDIR)/graphs.plot
	$(GNUPLOT)
$(DDIR)/graphs.csv: $(SDIR)/graphs.pl
	$(GENCSV)

$(NAMES): $(SDIR)/all.txt
	cp $(SDIR)/all.txt $@

$(GDIR)/ifdef-over-time.svg: $(INCLUDE) $(DDIR)/ifdef-over-time.csv $(DDIR)/ifdef-per-kloc.csv
	$(GNUPLOT)
$(DDIR)/ifdef-over-time.csv: $(SDIR)/ifdef-over-time.pl
	$(GENCSV)
$(DDIR)/ifdef-per-kloc.csv: $(DDIR)/ifdef-over-time.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/ifdef-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/atoi-over-time.svg: $(INCLUDE) $(DDIR)/atoi-over-time.csv $(DDIR)/atoi-per-kloc.csv
	$(GNUPLOT)
$(DDIR)/atoi-over-time.csv: $(SDIR)/atoi-over-time.pl
	$(GENCSV)
$(DDIR)/atoi-per-kloc.csv: $(DDIR)/atoi-over-time.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/atoi-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/cve-pie-chart.svg: $(INCLUDE) $(DDIR)/cve-pie-chart.csv
	$(GNUPLOT)
$(DDIR)/cve-pie-chart.csv: $(SDIR)/cve-pie-chart.pl
	$(GENCSV)

$(GDIR)/top-remains.svg: $(INCLUDE) $(DDIR)/top-remains.csv
	$(GNUPLOT)
$(DDIR)/top-remains.csv: $(SDIR)/top-remains.pl
	$(GENCSV)

$(GDIR)/remains-per-kloc.svg: $(INCLUDE) $(DDIR)/remains-per-kloc.csv
	$(GNUPLOT)
$(DDIR)/remains-per-kloc.csv: $(DDIR)/authorremains.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/authorremains.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/manpage-lines-per-option.svg: $(INCLUDE) $(DDIR)/manpage-lines-per-option.csv
	$(GNUPLOT)
$(DDIR)/manpage-lines-per-option.csv: $(DDIR)/manpage.csv $(DDIR)/cmdline-options-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/manpage.csv $(DDIR)/cmdline-options-over-time.csv 1:2 0:1 > $@

$(GDIR)/lines-per-author.svg: $(INCLUDE) $(DDIR)/lines-per-author.csv $(DDIR)/lines-per-contributor.csv
	$(GNUPLOT)
$(DDIR)/lines-per-contributor.csv:$(DDIR)/contributors-over-time.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/contributors-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@
$(DDIR)/lines-per-author.csv: $(DDIR)/authors.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/authors.csv $(DDIR)/lines-over-time.csv 0:2 0:1 1000 > $@

$(GDIR)/knownvulns-per-line.svg: $(INCLUDE) $(DDIR)/knownvulns-per-line.csv
	$(GNUPLOT)
$(DDIR)/knownvulns-per-line.csv: $(DDIR)/vulns-releases.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/vulns-releases.csv $(DDIR)/lines-over-time.csv 0:2 0:1 1000 > $@

$(GDIR)/vulns-releases.svg: $(INCLUDE) $(DDIR)/vulns-releases.csv $(SDIR)/vulns-releases.plot
	$(GNUPLOT)
$(DDIR)/vulns-releases.csv: $(SDIR)/vulns-releases.pl
	$(GENCSV)

$(GDIR)/lines-per-test.svg: $(INCLUDE) $(DDIR)/lines-per-test.csv
	$(GNUPLOT)
$(DDIR)/lines-per-test.csv: $(DDIR)/tests-over-time.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/tests-over-time.csv $(DDIR)/lines-over-time.csv 1:2 0:1 1000 > $@

$(GDIR)/lines-per-docs.svg: $(INCLUDE) $(DDIR)/lines-per-docs.csv
	$(GNUPLOT)
$(DDIR)/lines-per-docs.csv: $(DDIR)/docs-over-time.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/docs-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/added-per-line.svg: $(INCLUDE) $(DDIR)/added-per-line.csv
	$(GNUPLOT)
$(DDIR)/addedcode.csv: $(SDIR)/addedcode.pl
	perl $(SDIR)/addedcode.pl >$@
$(DDIR)/added-per-line.csv: $(DDIR)/addedcode.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/addedcode.csv $(DDIR)/lines-over-time.csv 0:1 0:1 >$@

$(GDIR)/h1-per-year.svg: $(INCLUDE) $(DDIR)/h1-reports.csv
	$(GNUPLOT)
$(DDIR)/h1-reports.csv:
	cp $(SDIR)/h1-reports.md $@

$(GDIR)/testinfra-per-test.svg: $(INCLUDE) $(DDIR)/testinfra-per-test.csv
	$(GNUPLOT)
$(DDIR)/testinfra-per-test.csv: $(DDIR)/testinfra-over-time.csv $(DDIR)/tests-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/testinfra-over-time.csv $(DDIR)/tests-over-time.csv 0:1 1:2 > $@

$(GDIR)/testinfra-per-line.svg: $(INCLUDE) $(DDIR)/testinfra-per-line.csv
	$(GNUPLOT)
$(DDIR)/testinfra-per-line.csv: $(DDIR)/testinfra-over-time.csv $(DDIR)/lines-over-time.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/testinfra-over-time.csv $(DDIR)/lines-over-time.csv 0:1 0:1 1000 > $@

$(GDIR)/loc-per-day.svg: $(INCLUDE) $(DDIR)/loc-per-day.csv $(SDIR)/loc-per-day.plot
	$(GNUPLOT)
$(DDIR)/loc-per-day.csv: $(DDIR)/lines-over-time.csv $(DDIR)/project-age.csv $(SDIR)/plotdivision.pl
	perl $(SDIR)/plotdivision.pl $(DDIR)/lines-over-time.csv $(DDIR)/project-age.csv 0:1 0:1 > $@

$(GDIR)/project-age.svg: $(INCLUDE) $(DDIR)/project-age.csv $(SDIR)/project-age.plot
	$(GNUPLOT)
$(DDIR)/project-age.csv: $(SDIR)/project-age.pl
	$(GENCSV)

$(GDIR)/testinfra-over-time.svg: $(INCLUDE) $(DDIR)/testinfra-over-time.csv
	$(GNUPLOT)
$(DDIR)/testinfra-over-time.csv: $(SDIR)/testinfra-over-time.pl
	$(GENCSV)

$(GDIR)/top-cwe.svg: $(INCLUDE) $(DDIR)/top-cwe.csv
	$(GNUPLOT)
$(DDIR)/top-cwe.csv: $(SDIR)/top-cwe.pl
	$(GENCSV)

$(GDIR)/codeage.svg: $(INCLUDE) $(DDIR)/codeage.csv
	$(GNUPLOT)
$(DDIR)/codeage.csv: $(SDIR)/codeage.pl
	$(GENCSV)

$(GDIR)/complex-dist.svg: $(INCLUDE) $(DDIR)/complex-dist.csv
	$(GNUPLOT)
$(DDIR)/complex-dist.csv: $(SDIR)/complex-dist.pl
	$(GENCSV)

$(GDIR)/line-complex.svg: $(INCLUDE) $(DDIR)/line-complex.csv
	$(GNUPLOT)
$(DDIR)/line-complex.csv: $(SDIR)/line-complex.pl
	$(GENCSV)

$(GDIR)/funclen.svg: $(INCLUDE) $(DDIR)/complexity.csv
	$(GNUPLOT)

$(GDIR)/complexity.svg: $(INCLUDE) $(DDIR)/complexity.csv
	$(GNUPLOT)
$(DDIR)/complexity.csv: $(SDIR)/complexity.pl
	$(GENCSV)

$(GDIR)/sscanf-over-time.svg: $(INCLUDE) $(DDIR)/sscanf-over-time.csv
	$(GNUPLOT)
$(DDIR)/sscanf-over-time.csv: $(SDIR)/sscanf-over-time.pl
	$(GENCSV)

$(GDIR)/strcpy-over-time.svg: $(INCLUDE) $(DDIR)/strcpy-over-time.csv
	$(GNUPLOT)
$(DDIR)/strcpy-over-time.csv: $(SDIR)/strcpy-over-time.pl
	$(GENCSV)

$(GDIR)/strncpy-over-time.svg: $(INCLUDE) $(DDIR)/strncpy-over-time.csv
	$(GNUPLOT)
$(DDIR)/strncpy-over-time.csv: $(SDIR)/strncpy-over-time.pl
	$(GENCSV)

$(GDIR)/cpy-over-time.svg: $(INCLUDE) $(DDIR)/cpy-over-time.csv
	$(GNUPLOT)
$(DDIR)/cpy-over-time.csv: $(SDIR)/cpy-over-time.pl
	$(GENCSV)

$(GDIR)/releases-per-year.svg: $(INCLUDE) $(DDIR)/releases-per-year.csv
	$(GNUPLOT)
$(DDIR)/releases-per-year.csv: $(SDIR)/releases-per-year.pl
	$(GENCSV)

$(GDIR)/release-number.svg: $(INCLUDE) $(DDIR)/release-number.csv
	$(GNUPLOT)
$(DDIR)/release-number.csv: $(SDIR)/release-number.pl
	$(GENCSV)

$(GDIR)/lines-person.svg: $(INCLUDE) $(DDIR)/lines-person.csv
	$(GNUPLOT)
$(DDIR)/lines-person.csv: $(SDIR)/lines-person.pl
	$(GENCSV)

$(GDIR)/contributors-per-release.svg: $(INCLUDE) $(DDIR)/contributors-per-release.csv
	$(GNUPLOT)
$(DDIR)/contributors-per-release.csv: $(SDIR)/contributors-per-release.pl
	$(GENCSV)

$(GDIR)/bugbounty-amounts.svg: $(INCLUDE) $(DDIR)/bugbounty-amounts.csv
	$(GNUPLOT)
$(DDIR)/bugbounty-amounts.csv: $(SDIR)/bugbounty-amounts.pl
	$(GENCSV)

$(GDIR)/bugbounty-over-time.svg: $(INCLUDE) $(DDIR)/bugbounty-over-time.csv
	$(GNUPLOT)
$(DDIR)/bugbounty-over-time.csv: $(SDIR)/bugbounty-over-time.pl
	$(GENCSV)

$(GDIR)/examples-over-time.svg: $(INCLUDE) $(DDIR)/examples-over-time.csv
	$(GNUPLOT)
$(DDIR)/examples-over-time.csv: $(SDIR)/examples-over-time.pl
	$(GENCSV)

$(GDIR)/manpage.svg: $(INCLUDE) $(DDIR)/manpage.csv
	$(GNUPLOT)
$(DDIR)/manpage.csv: $(SDIR)/manpage.pl
	$(GENCSV)

$(GDIR)/manpages-over-time.svg: $(INCLUDE) $(DDIR)/manpages-over-time.csv
	$(GNUPLOT)
$(DDIR)/manpages-over-time.csv: $(SDIR)/manpages-over-time.pl
	$(GENCSV)

$(GDIR)/tests-over-time.svg: $(INCLUDE) $(DDIR)/tests-over-time.csv
	$(GNUPLOT)
$(DDIR)/tests-over-time.csv: $(SDIR)/tests-over-time.pl
	$(GENCSV)

$(GDIR)/lines-per-month.svg: $(INCLUDE) $(DDIR)/lines-per-month.csv
	$(GNUPLOT)
$(DDIR)/lines-per-month.csv: $(SDIR)/lines-per-month.pl
	$(GENCSV)

$(GDIR)/lines-over-time.svg: $(INCLUDE) $(DDIR)/lines-over-time.csv
	$(GNUPLOT)
$(DDIR)/lines-over-time.csv: $(SDIR)/lines-over-time.pl
	$(GENCSV)

$(GDIR)/severity.svg: $(INCLUDE) $(DDIR)/severity.csv
	$(GNUPLOT)
$(DDIR)/severity.csv: $(SDIR)/severity.pl
	$(GENCSV)

$(GDIR)/sev-per-year.svg: $(INCLUDE) $(DDIR)/sev-per-year.csv $(SDIR)/sev-per-year.plot
	$(GNUPLOT)
$(DDIR)/sev-per-year.csv: $(SDIR)/sev-per-year.pl
	$(GENCSV)

$(GDIR)/cvuln-per-year.svg: $(INCLUDE) $(DDIR)/cvuln-per-year.csv $(SDIR)/cvuln-per-year.plot
	$(GNUPLOT)
$(DDIR)/cvuln-per-year.csv: $(SDIR)/cvuln-per-year.pl
	$(GENCSV)

$(GDIR)/cvuln-per-year-intro.svg: $(INCLUDE) $(DDIR)/cvuln-per-year-intro.csv $(SDIR)/cvuln-per-year-intro.plot
	$(GNUPLOT)
$(DDIR)/cvuln-per-year-intro.csv: $(SDIR)/cvuln-per-year-intro.pl
	$(GENCSV)

$(GDIR)/high-vuln-reports.svg: $(INCLUDE) $(DDIR)/high-vuln-reports.csv
	$(GNUPLOT)
$(DDIR)/high-vuln-reports.csv: $(SDIR)/high-vuln-reports.pl
	$(GENCSV)

$(GDIR)/c-vuln-reports.svg: $(INCLUDE) $(DDIR)/c-vuln-reports.csv
	$(GNUPLOT)
$(DDIR)/c-vuln-reports.csv: $(SDIR)/c-vuln-reports.pl
	$(GENCSV)

$(GDIR)/c-vuln-code.svg: $(INCLUDE) $(DDIR)/c-vuln-code.csv
	$(GNUPLOT)
$(DDIR)/c-vuln-code.csv: $(SDIR)/c-vuln-code.pl
	$(GENCSV)

$(GDIR)/vulns-per-year.svg: $(INCLUDE) $(DDIR)/vulns-per-year.csv
	$(GNUPLOT)
$(DDIR)/vulns-per-year.csv: $(SDIR)/vulns-per-year.pl
	perl $(SDIR)/vulns-per-year.pl $(WDIR) $(DDIR)/cve-intro.csv > $@

$(GDIR)/vulns-over-time.svg: $(INCLUDE) $(DDIR)/vulns-over-time.csv $(DDIR)/cve-intro.csv
	$(GNUPLOT)
$(DDIR)/vulns-over-time.csv: $(SDIR)/vulns-over-time.pl
	$(GENCSV)
$(DDIR)/cve-intro.csv: $(SDIR)/cve-intro.pl
	$(GENCSV)

$(GDIR)/cve-fixtime.svg: $(INCLUDE) $(DDIR)/cve-fixtime.csv
	$(GNUPLOT)
$(DDIR)/cve-fixtime.csv: $(SDIR)/cve-fixtime.pl
	$(GENCSV)

$(GDIR)/cve-age.svg: $(INCLUDE) $(DDIR)/cve-age.csv
	$(GNUPLOT)
$(DDIR)/cve-age.csv: $(SDIR)/cve-age.pl
	$(GENCSV)

$(GDIR)/vuln-dist-code.svg: $(INCLUDE) $(DDIR)/vuln-dist-code.csv
	$(GNUPLOT)
$(DDIR)/vuln-dist-code.csv: $(SDIR)/vuln-dist-code.pl
	$(GENCSV)

$(GDIR)/docs-over-time.svg: $(INCLUDE) $(DDIR)/docs-over-time.csv
	$(GNUPLOT)
$(DDIR)/docs-over-time.csv: $(SDIR)/docs-over-time.pl
	$(GENCSV)

$(GDIR)/commits-per-month.svg: $(INCLUDE) $(DDIR)/commits-per-month.csv
	$(GNUPLOT)
$(DDIR)/commits-per-month.csv: $(SDIR)/commits-per-month.pl
	$(GENCSV)

$(GDIR)/firsttimers.svg: $(INCLUDE) $(DDIR)/firsttimers.csv
	$(GNUPLOT)
$(DDIR)/firsttimers.csv: $(SDIR)/firsttimers.pl
	$(GENCSV)

$(GDIR)/authors-per-month.svg: $(INCLUDE) $(DDIR)/authors-per-month.csv
	$(GNUPLOT)
$(DDIR)/authors-per-month.csv: $(SDIR)/authors-per-month.pl
	$(GENCSV)

$(GDIR)/symbols-over-time.svg: $(INCLUDE) $(DDIR)/symbols-over-time.csv
	$(GNUPLOT)
$(DDIR)/symbols-over-time.csv: $(SDIR)/symbols-over-time.pl
	$(GENCSV)

$(GDIR)/todo-over-time.svg: $(INCLUDE) $(DDIR)/todo-over-time.csv
	$(GNUPLOT)
$(DDIR)/todo-over-time.csv: $(SDIR)/todo-over-time.pl
	$(GENCSV)

$(GDIR)/authorremains-top.svg: $(INCLUDE) $(DDIR)/authorremains.csv
	$(GNUPLOT)

$(GDIR)/authorremains.svg: $(INCLUDE) $(DDIR)/authorremains.csv
	$(GNUPLOT)
$(DDIR)/authorremains.csv: $(SDIR)/authorremains.pl
	$(GENCSV)

$(GDIR)/authors.svg: $(INCLUDE) $(DDIR)/authors.csv
	$(GNUPLOT)
$(DDIR)/authors.csv: $(SDIR)/authors.pl
	$(GENCSV)

$(GDIR)/contributors-over-time.svg: $(INCLUDE) $(DDIR)/contributors-over-time.csv
	$(GNUPLOT)
$(DDIR)/contributors-over-time.csv: $(SDIR)/contributors-over-time.pl
	perl $(SDIR)/contributors-over-time.pl | cut '-d;' -f2- > $@

$(GDIR)/cmdline-options-over-time.svg: $(INCLUDE) $(DDIR)/cmdline-options-over-time.csv
	$(GNUPLOT)
$(DDIR)/cmdline-options-over-time.csv: $(SDIR)/cmdline-options-over-time.pl
	$(GENCSV)

$(GDIR)/commits-per-release.svg: $(INCLUDE) $(DDIR)/commits-per-release.csv
	$(GNUPLOT)
$(DDIR)/commits-per-release.csv: $(SDIR)/commits-per-release.pl
	$(GENCSV)

$(GDIR)/days-per-release.svg: $(INCLUDE) $(DDIR)/days-per-release.csv
	$(GNUPLOT)
$(DDIR)/days-per-release.csv: $(SDIR)/days-per-release.pl
	$(GENCSV)

$(GDIR)/setopts-over-time.svg: $(INCLUDE) $(DDIR)/setopts-over-time.csv
	$(GNUPLOT)
$(DDIR)/setopts-over-time.csv:
	perl $(SDIR)/setopts-over-time.pl | cut '-d;' -f2- >$@

$(GDIR)/filesize-over-time.svg: $(INCLUDE) $(DDIR)/filesize-over-time.csv
	$(GNUPLOT)
$(DDIR)/filesize-over-time.csv: $(SDIR)/filesize-over-time.pl
	$(GENCSV)

$(GDIR)/comments.svg: $(INCLUDE) $(DDIR)/comments.csv
	$(GNUPLOT)
$(DDIR)/comments.csv: $(SDIR)/comments.pl
	$(GENCSV)

$(GDIR)/50-percent.svg: $(INCLUDE) $(DDIR)/50-percent.csv
	$(GNUPLOT)
$(DDIR)/50-percent.csv: $(SDIR)/80-percent.pl
	perl $(SDIR)/80-percent.pl 50 > $@

$(GDIR)/60-percent.svg: $(INCLUDE) $(DDIR)/60-percent.csv
	$(GNUPLOT)
$(DDIR)/60-percent.csv: $(SDIR)/80-percent.pl
	perl $(SDIR)/80-percent.pl 60 > $@

$(GDIR)/70-percent.svg: $(INCLUDE) $(DDIR)/70-percent.csv
	$(GNUPLOT)
$(DDIR)/70-percent.csv: $(SDIR)/80-percent.pl
	perl $(SDIR)/80-percent.pl 70 > $@

$(GDIR)/80-percent.svg: $(INCLUDE) $(DDIR)/80-percent.csv
	$(GNUPLOT)
$(DDIR)/80-percent.csv: $(SDIR)/80-percent.pl
	perl $(SDIR)/80-percent.pl 80 > $@

$(GDIR)/90-percent.svg: $(INCLUDE) $(DDIR)/90-percent.csv
	$(GNUPLOT)
$(DDIR)/90-percent.csv: $(SDIR)/80-percent.pl
	perl $(SDIR)/80-percent.pl 90 > $@

$(GDIR)/95-percent.svg: $(INCLUDE) $(DDIR)/95-percent.csv
	$(GNUPLOT)
$(DDIR)/95-percent.csv: $(SDIR)/80-percent.pl
	perl $(SDIR)/80-percent.pl 95 > $@

$(GDIR)/coreteam-per-year.svg: $(INCLUDE) $(DDIR)/coreteam-per-year.csv $(DDIR)/coreteam-percent.csv
	$(GNUPLOT)
$(DDIR)/coreteam-per-year.csv: $(SDIR)/coreteam-over-time.pl
	perl $(SDIR)/coreteam-over-time.pl | grep "^[12]" | tr -d '(' | awk '{ print $$1"-01-01;"$$2; }' >$@
$(DDIR)/coreteam-percent.csv: $(SDIR)/coreteam-over-time.pl
	perl $(SDIR)/coreteam-over-time.pl | grep '^[12]' | cut -d" " -f 1,5 | tr -d '%' | awk '{ if($$2 > 0) {print $$1"-01-01;"$$2; }}' > $@

$(GDIR)/commits-over-time.svg: $(INCLUDE) $(DDIR)/commits-over-time.csv
	$(GNUPLOT)
$(DDIR)/commits-over-time.csv: $(SDIR)/commits-over-time.pl
	$(GENCSV)

$(GDIR)/commits-per-year.svg: $(INCLUDE) $(DDIR)/commits-per-year.csv
	$(GNUPLOT)
$(DDIR)/commits-per-year.csv: $(SDIR)/commits-per-year.pl
	$(GENCSV)

$(GDIR)/authors-active.svg: $(INCLUDE) $(DDIR)/authors-active.csv
	$(GNUPLOT)
$(DDIR)/authors-active.csv: $(SDIR)/authors-active.pl
	$(GENCSV)

$(GDIR)/authors-per-year.svg: $(INCLUDE) $(DDIR)/authors-per-year.csv
	$(GNUPLOT)
$(DDIR)/authors-per-year.csv: $(SDIR)/authors-per-year.pl
	$(GENCSV)

$(GDIR)/daniel-commit-share.svg: $(INCLUDE) $(DDIR)/daniel-commit-share.csv
	$(GNUPLOT)
$(DDIR)/daniel-commit-share.csv: $(SDIR)/daniel-commit-share.pl
	$(GENCSV)

$(GDIR)/daniel-vs-rest.svg: $(INCLUDE) $(DDIR)/daniel-vs-rest.csv
	$(GNUPLOT)
$(DDIR)/daniel-vs-rest.csv: $(SDIR)/daniel-vs-rest.pl
	$(GENCSV)

$(GDIR)/http-over-time.svg: $(INCLUDE) $(DDIR)/http-over-time.csv
	$(GNUPLOT)
$(DDIR)/http-over-time.csv: $(SDIR)/http-over-time.pl
	$(GENCSV)

$(GDIR)/3rdparty-over-time.svg: $(INCLUDE) $(DDIR)/3rdparty-over-time.csv $(SDIR)/3rdparty-over-time.plot
	$(GNUPLOT)
$(DDIR)/3rdparty-over-time.csv: $(SDIR)/3rdparty-over-time.pl
	$(GENCSV)

$(GDIR)/backends-over-time.svg: $(INCLUDE) $(BACKENDCSV) $(SDIR)/backends-over-time.plot
	$(GNUPLOT)
$(DDIR)/tls-over-time.csv: $(SDIR)/tls-over-time.pl
	$(GENCSV)
$(DDIR)/ssh-over-time.csv: $(SDIR)/ssh-over-time.pl
	$(GENCSV)
$(DDIR)/h1-over-time.csv: $(SDIR)/h1-over-time.pl
	$(GENCSV)
$(DDIR)/h2-over-time.csv: $(SDIR)/h2-over-time.pl
	$(GENCSV)
$(DDIR)/h3-over-time.csv: $(SDIR)/h3-over-time.pl
	$(GENCSV)
$(DDIR)/idn-over-time.csv: $(SDIR)/idn-over-time.pl
	$(GENCSV)
$(DDIR)/resolver-over-time.csv: $(SDIR)/resolver-over-time.pl
	$(GENCSV)

$(GDIR)/gh-fixes.svg: $(INCLUDE) $(DDIR)/gh-fixes.csv $(SDIR)/gh-fixes.plot
	$(GNUPLOT)
$(DDIR)/gh-fixes.csv: $(DDIR)/github.csv $(SDIR)/gh-fixes.pl
	perl $(SDIR)/gh-fixes.pl $(DDIR)/github.csv > $@

$(GDIR)/gh-age.svg: $(INCLUDE) $(DDIR)/gh-age.csv
	$(GNUPLOT)
$(DDIR)/gh-age.csv: $(DDIR)/github.csv $(DDIR)/github.csv
	perl $(SDIR)/gh-age.pl $(DDIR)/github.csv > $@

$(GDIR)/gh-monthly.svg: $(INCLUDE) $(DDIR)/gh-monthly.csv
	$(GNUPLOT)
$(DDIR)/gh-monthly.csv: $(DDIR)/github.csv
	perl $(SDIR)/gh-monthly.pl $(DDIR)/github.csv > $@

$(GDIR)/gh-open.svg: $(INCLUDE) $(DDIR)/gh-open.csv $(SDIR)/gh-open.plot
	$(GNUPLOT)
$(DDIR)/gh-open.csv: $(DDIR)/github.csv $(SDIR)/gh-open.pl
	perl $(SDIR)/gh-open.pl $(DDIR)/github.csv > $@

$(DDIR)/github.csv: $(SDIR)/github-json.pl
	perl $(SDIR)/github-json.pl > $@

$(GDIR)/protocols-over-time.svg: $(INCLUDE) $(DDIR)/protocols-over-time.csv
	$(GNUPLOT)
$(DDIR)/protocols-over-time.csv: $(SDIR)/protocols-over-time.pl
	$(GENCSV)

$(GDIR)/API-calls-over-time.svg: $(INCLUDE) $(DDIR)/API-calls-over-time.csv
	$(GNUPLOT)
$(DDIR)/API-calls-over-time.csv: $(SDIR)/API-calls-over-time.pl
	$(GENCSV)

$(GDIR)/bugfix-frequency.svg: $(INCLUDE) $(DDIR)/bugfix-frequency.csv
	$(GNUPLOT)
$(DDIR)/bugfix-frequency.csv: $(SDIR)/bugfix-frequency.pl
	$(GENCSV)

$(GDIR)/files-over-time.svg: $(INCLUDE) $(DDIR)/files-over-time.csv
	$(GNUPLOT)
$(DDIR)/files-over-time.csv: $(SDIR)/files-over-time.pl
	$(GENCSV)

$(GDIR)/mail.svg: $(INCLUDE) $(DDIR)/mail.csv
	$(GNUPLOT)
$(DDIR)/mail.csv: $(SDIR)/mail.pl
	$(GENCSV)

$(GDIR)/contrib-tail.svg: $(INCLUDE) $(DDIR)/contrib-tail.csv
	$(GNUPLOT)
$(DDIR)/contrib-tail.csv: $(SDIR)/contrib-tail.pl
	$(GENCSV)

$(GDIR)/weekday-of-year.svg: $(INCLUDE) $(DDIR)/weekday-of-year.csv
	$(GNUPLOT)
$(DDIR)/weekday-of-year.csv: $(SDIR)/weekday-of-year.pl
	$(GENCSV)

$(GDIR)/date-of-year.svg: $(INCLUDE) $(DDIR)/date-of-year.csv
	$(GNUPLOT)
$(DDIR)/date-of-year.csv: $(SDIR)/date-of-year.pl
	$(GENCSV)

$(GDIR)/month-of-year.svg: $(INCLUDE) $(DDIR)/month-of-year.csv
	$(GNUPLOT)
$(DDIR)/month-of-year.csv: $(SDIR)/month-of-year.pl
	$(GENCSV)

$(GDIR)/512-mb.svg: $(INCLUDE) $(DDIR)/512-mb.csv
	$(GNUPLOT)
$(DDIR)/512-mb.csv:
	cp $(SDIR)/512-mb.csv $@

$(GDIR)/multi-handle.svg: $(INCLUDE) $(DDIR)/multi-handle.csv
	$(GNUPLOT)
$(DDIR)/multi-handle.csv:
	cp $(SDIR)/multi-handle.csv $@

$(GDIR)/easy-handle.svg: $(INCLUDE) $(DDIR)/easy-handle.csv
	$(GNUPLOT)
$(DDIR)/easy-handle.csv:
	cp $(SDIR)/easy-handle.csv $@

$(GDIR)/connectdata.svg: $(INCLUDE) $(DDIR)/connectdata.csv
	$(GNUPLOT)
$(DDIR)/connectdata.csv:
	cp $(SDIR)/connectdata.csv $@

clean:
	rm -f $(CSV) $(GRAPHS) $(NAMES)
