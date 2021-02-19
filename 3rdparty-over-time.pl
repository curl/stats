#!/usr/bin/perl

print <<MOO
1998-03-20;;0
MOO
    ;

open(T, "<stats/3rdparty-history.md");
while(<T>) {
    chomp;
    if($_ =~ /^(\d\d\d\d-\d\d-\d\d) (.*)/) {
        my ($date, $lib)=($1, $2);
        if($lib =~ /^-/) {
            $count--;
        }
        else {
            $count++;
        }
        print "$date;$lib;$count\n";
        $end = $count;
    }
}
close(T);

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "%04d-%02d-%02d;;%d\n", $year + 1900, $mon + 1, $mday, $end;
