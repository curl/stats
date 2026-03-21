#!/usr/bin/perl

open(T, "<stats/protocol-history.md");
while(<T>) {
    chomp;
    if($_ =~ /^([^ ]*) (\d\d\d\d-\d\d-\d\d)/) {
        my $p = $1;
        my $d = $2;
        if($p =~ /^-/) {
            $c--;
        }
        else {
            $c++;
        }

        print "$d;$p;$c\n";
        $end = $c;
    }
}
close(T);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "%04d-%02d-%02d;;%d\n", $year + 1900, $mon + 1, $mday, $end;
