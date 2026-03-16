#!/usr/bin/perl

open(G, "git log --since=2010-03-20 --date=format:%z 2>/dev/null|");
my $date;
my $lines;
my @all;
while(<G>) {
    chomp;
    if(/^Date: +([+-])(\d\d\d\d)/) {
        my ($plus, $tz) = ($1, $2);
        if($tz % 100) {
            # move the partial hour into the full hour slot
            $tz -= $tz % 100;
            $tz = sprintf "%04u", $tz;
        }
        $all{$plus.$tz}++;
    }
}
close(G);

my $index = 0;
for ($t = -1000; $t <= +1300; $t += 100) {
    my $tz = sprintf("%0+5d", $t);
    printf "%d;%s;%d\n", $index++, $tz, $all{$tz}
}
