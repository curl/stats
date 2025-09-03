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
$csv = "$webroot/docs/releases.csv";

sub relinfo {
    open(C, "<$csv");
    while(<C>) {
        chomp;
        my ($index, $version, $vulns, $date, $since, $ddays, $adays, $dbugs, $abugs,
            $dchanges, $achanges) = split(';', $_);
        $release{$version}=$date;
        push @inorder, $version;
        $p = $date; # remmeber the last date, which is the earliest
    }
    close(C);
}

relinfo();

sub deltadays {
    my ($prev, $date) = @_;
    my $psecs = `date +%s -d "$prev"`;
    my $secs = `date +%s -d "$date"`;
    return int(($secs-$psecs)/86400);
}

for my $r (reverse @inorder) {
    printf "%s;%u;%d;%d\n", $release{$r},
        deltadays("1996-11-11", $release{$r}),
        deltadays("1998-03-20", $release{$r}),
        deltadays("2000-08-07", $release{$r});
}
