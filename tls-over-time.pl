#!/usr/bin/perl

print <<MOO
1998-03-20;;0
MOO
    ;

open(T, "<stats/tls-history.md");
while(<T>) {
    chomp;
    if($_ =~ /^(.*) (\d\d\d\d-\d\d-\d\d) (\d+)/) {
        print "$2;$1;$3\n";
        $end = $3;
    }
}
close(T);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "%04d-%02d-%02d;;%d\n", $year + 1900, $mon + 1, $mday, $end;
