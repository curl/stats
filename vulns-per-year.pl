#!/usr/bin/perl

# number of vulns reported per year
#
my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";


for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date)=split('\|');
    my $year=int($date/10000);
    $v{$year}++;
}

for(1998 .. 2020) {
    $total += $v{$_};
    # writes a full date just to be parsable
    printf "%d-01-01;%d;%d\n", $_, $v{$_}, $total;
}
