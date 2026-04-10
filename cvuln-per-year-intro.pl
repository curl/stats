#!/usr/bin/perl

# C mistakes vs non-C mistakes per year
#
my $webroot = $ARGV[0] || "../curl-www";
$csv = "$webroot/docs/releases.csv";
require "$webroot/docs/vuln.pm";

sub buginfo {
    open(C, "<$csv") || die "no CSV";
    while(<C>) {
        chomp;
        my ($index, $version, $vulns, $date) = split(';', $_);
        $release{$version} = $date;
        #print STDERR "bug: $version\n";
    }
    close(C);
}

buginfo();

for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date,
        $report, $cwe, $award, $area, $cissue, $where, $severity)=split('\|');

    # date of introduction
    my $date = $release{$start};
    if(!$date) {
        die "bad date?";
    }
    my $year=int($date);

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
