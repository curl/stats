#!/usr/bin/perl

print <<MOO
1998-03-20;native;1
MOO
    ;

open(T, "<stats/h1-history.md");
while(<T>) {
    chomp;
    if($_ =~ /^(.*) (\d\d\d\d-\d\d-\d\d) (\d+)/) {
        print "$2;$1;$3\n";
        $end = $3;
    }
}
close(T);
