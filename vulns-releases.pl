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
        $vulns{$version}=$vulns;
        push @inorder, $version;
        $p = $date; # remmeber the last date, which is the earliest
    }
    close(C);
}

relinfo();

for my $v (reverse @inorder) {
    printf "%s;%s;%d\n", $release{$v}, $v, $vulns{$v}
}
