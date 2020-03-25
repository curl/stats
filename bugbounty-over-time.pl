#!/usr/bin/perl

# Bug bounty payouts from the curl project over time
#

my $webroot = $ARGV[0] || "../curl-www";

require "$webroot/docs/vuln.pm";

my $total;
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $report, $cwd, $usd)=split('\|');
    my $y, $m, $d;
    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/) {
        ($y, $m, $d)=($1, $2, $3);
    }
    my $nice = sprintf("%04d-%02d-%02d", $y, $m, $d);
    $total += $usd;
    $date{$cve} = $nice;
    $money{$cve} = $total;
    $bounty{$cve} = $usd;
    push @all, $cve;
}

my $l;

print <<START
1998-03-20;0;0
START
    ;

for my $cve (@all) {
    printf "%s;%s;%d;%d\n", $cve, $date{$cve}, $money{$cve}, $bounty{$cve};
}
