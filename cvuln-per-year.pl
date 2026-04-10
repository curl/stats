#!/usr/bin/perl

# C mistakes vs non-C mistakes per year
#
my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";

for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date,
        $report, $cwe, $award, $area, $cissue, $where, $severity)=split('\|');
    my $year=int($date/10000);
    if($cissue ne "-") {
        $cvuln{$year}++;
    }
    else {
        $nonc{$year}++
    }
}

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
$year += 1900;

# go to this year
for my $y (1998 .. $year) {
    printf "%d-01-01;%d;%d\n", $y, $cvuln{$y}, $nonc{$y};
}
