#!/usr/bin/perl

open(T, "<stats/ssh-history.md");
while(<T>) {
    chomp;
    if($_ =~ /^(.*) (\d\d\d\d-\d\d-\d\d) (\d+)/) {
        print "$2;$1;$3\n";
        $end = $3;
    }
}
close(T);
