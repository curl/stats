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
    if($usd) {
        push @all, $cve;
    }
}

my $l;

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum / scalar(@p);
}

my $i=0;
for my $cve (@all) {
    push @pp, $bounty{$cve};
    if(scalar(@pp) > 5) {
        shift @pp;
    }
    printf "%d;%s;%s;%d;%.1f\n",
        ++$i, $cve, $date{$cve}, $bounty{$cve}, average(@pp);
}
