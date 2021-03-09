#!/usr/bin/perl

#
# Count authors and single-commit authors
#

open(G, "git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full --stat|");

my $auth="";
while(<G>) {
    chomp;
    my $line = $_;
    if(/^Author: *([^\<]*) \</) {
        ($auth)=($1);
    }
    elsif($auth && /^CommitDate: (.*)/) {
        my $date;
        if($1 =~ /^(\d\d\d\d-\d\d-\d\d)/) {
            $date = $1;
        }
        $uniq{$auth}++;
        if($uniq{$auth} == 1) {
            $uniqdate{$auth} = $date;
            $dateauth{$date} .= "$auth,";
            $dates{$date}++;
        }
        $uniqcount{$date}=scalar(keys %uniq);
    }
    elsif($line =~ /^commit/) {
        # start a new
        $auth="";
    }
}
close(G);

my $singlec;
my $tenc;
my $fivec;
my $twoc;
my $o;
for my $d (sort keys %dates) {
    #printf "%s: %s\n", $d, $dateauth{$d};
    my @w = split(/,/, $dateauth{$d});
    for my $a (@w) {
        # only single commit authors
        if($uniq{$a} == 1) {
            $singlec++;
        }
        if($uniq{$a} >= 10) {
            $tenc++;
        }
        if($uniq{$a} >= 5) {
            $fivec++;
        }
        if($uniq{$a} >= 2) {
            $twoc++;
        }
        # $a is the author
        $o = sprintf "%d;%d;%.2f;%d;%d;%d",
            $singlec, $uniqcount{$d},
            $singlec*100/$uniqcount{$d}, $tenc, $fivec, $twoc;
        print "$d;$o\n";
    }
}

# repeat the last line with current date
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
$date = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
print "$date;$o\n";
