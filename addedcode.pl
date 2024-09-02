#!/usr/bin/perl

open(G, "git log --reverse --stat --date=short -- src lib include 2>/dev/null|");
my $date;
my $lines;
while(<G>) {
    if(/^Date: *(\d\d\d\d-\d\d-\d\d)/) {
        $date = $1;
    }
    if(/changed, (\d*) insertion/) {
        if(!$date) {
            die "bad: $1";
        }
        $lines += $1;
        print "$date;$lines;$1\n";
        undef $date;
    }
    chomp;
}
close(G);
