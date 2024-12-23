#!/usr/bin/perl

open(G, "git log --since=2010-03-20 --date=format:%z 2>/dev/null|");
my $date;
my $lines;
while(<G>) {
    chomp;
    if(/^Date: .*([+-]\d\d\d\d)/) {
        my $tz = $1;
        $all{$tz}++;
    }
}
close(G);

for ($t = -1000; $t <= +1300; $t += 100) {
    my $tz = sprintf("%0+5d", $t);
    printf "%d;%s;%d\n", $index++, $tz, $all{$tz}
}
