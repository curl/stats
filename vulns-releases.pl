#!/usr/bin/perl

# NOTE:
#
# This accesses the web site git repo to find the 'vuln.pm' file with the
# proper meta-data!
#
# Shows the number of days each CVE was present in a curl release before
# fixed.
#

my $webroot = $ARGV[0] || "../curl-www";

require "$webroot/docs/vuln.pm";
require "./stats/releases.pm";
my $csv = "$webroot/docs/releases.csv";

my @releases = allreleases();

my %reldate;

# figure out release dates per release
open(C, "<$csv");
while(<C>) {
    chomp;
    my ($index, $version, $vulns, $date, $since, $ddays, $adays, $dbugs, $abugs,
        $dchanges, $achanges) = split(';', $_);
    $reldate{$version} = $date;
}
close(C);


# all known vulnerabilities
for my $c (@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $report, $cwe,
        $award, $area, $cissue, $where, $level)=split('\|', $c);

    for my $v (@releases) {
        if((vernum($v) >= vernum($start)) && (vernum($v) <= vernum($stop))) {
            # the $c vuln existed in the $v release
            #print "$id ($level) existed in $v\n";
            $all{$v}++;
            $severity{$level, $v}++;
        }
    }
}


for my $r (@releases) {
    printf "%s;%s;%u;", $reldate{$r}, $r, $all{$r};
    my $count = 0;
    for my $l ('critical', 'high', 'medium', 'low') {
        $count += $severity{$l, $r}; # accumulate
        printf "%u;", $count;
    }
    print "\n";
}
