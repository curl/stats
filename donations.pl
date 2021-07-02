#!/usr/bin/perl

# Open Collective donations to curl, over time
# The CSV is a manual export from Open Collective

open(D, "<stats/opencollective.csv") ||
    die "cant find CSV";

my $c;
while(<D>) {
    # skip first line
    next if(!$c++);
    chompe;
    if(/^\"([^"]*)\",\"([^"]*)\",\"([^"]*)\",(\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d),\"USD\",\"USD\",([0-9.]+),([0-9.-]+),([0-9.-]+),([0-9.-]+),([0-9.]+)/) {
        my ($desc, $who, $url, $when, $amount,$hostfee,$ocfee,$ppfee,$net)=($1,$2,$3,$4,$5,$6,$7,$8,$9);
        my $mon;
        if($when =~ /^(\d\d\d\d-\d\d)/) {
            $mon = $1;
        }
        $permonth{$mon} += $amount;
        $netmonth{$mon} += $net;

        #printf "%s;%s;%s\n", $when, $amount, $net;
    }
}

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum / scalar(@p);
}

for my $m (sort keys %permonth) {
    my $money = $permonth{$m};
    my $net = $netmonth{$m};
    $totusd += $money;
    $totnet += $net;
    $mons++;
    push @pp, $money;
    if(scalar(@pp) > 12) {
        shift @pp;
    }
    printf "%s-01;%d;%d;%u;%.1f\n", $m, $money, average(@pp), $totnet,
        $totusd/$mons;
}
