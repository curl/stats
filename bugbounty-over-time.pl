#!/usr/bin/perl

# Bug bounty payouts from the curl project over time
#

require "../curl-www/docs/vuln.pm";

my $total;
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $report, $cwd, $usd)=split('\|');
    my $y, $m, $d;
    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/) {
        ($y, $m, $d)=($1, $2, $3);
    }
    my $nice = sprintf("%04d-%02d-%02d", $y, $m, $d);
    $total += $usd;
    $money{$nice} = $total;
}

my $l;

print <<START
1998-03-20;0
START
    ;

for my $y (sort keys %money) {
    my $usd = $money{$y};
    if($usd) {
        printf "%s;%d\n", $y, $usd;
    }
}
