#!/usr/bin/perl

open(T, "<stats/planet-history.md");
while(<T>) {
    chomp;
    if($_ =~ /^([^ ]*) (\d\d\d\d-\d\d-\d\d)/) {
        $c++;
        print "$2;$1;$c\n";
    }
}
close(T);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "%04d-%02d-%02d;;$c\n", $year + 1900, $mon + 1, $mday, $end;
