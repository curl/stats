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
        $donation{$url} += $amount;
    }
}

$c = 1;
for my $w (sort {$donation{$b} <=> $donation{$a}} keys %donation) {
    printf "%s;%u;%u\n", $w, $c++, $donation{$w};
}
