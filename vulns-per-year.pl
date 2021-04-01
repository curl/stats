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

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
$year += 1900;

# go to this year
for(1998 .. $year) {
    $total += $v{$_};
    # writes a full date just to be parsable
    printf "%d-01-01;%d;%d\n", $_, $v{$_}, $total;
}
