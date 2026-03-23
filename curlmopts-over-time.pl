#!/usr/bin/perl

require "./stats/tag2date.pm";

sub num {
    my ($t)=@_;
    if($t =~ /^curl-(\d)_(\d+)_(\d+)/) {
        return 10000*$1 + 100*$2 + $3;
    }
    elsif($t =~ /^curl-(\d)_(\d+)/) {
        return 10000*$1 + 100*$2;
    }
}


sub sortthem {
    return num($a) <=> num($b);
}

@alltags= `git tag -l`;

foreach my $t (@alltags) {
    chomp $t;
    if($t =~ /^curl-([0-9_]*[0-9])\z/) {
        push @releases, $t;
    }
}

sub options {
    my @file = @_;
    my $c = 0;
    foreach $f (@file) {
        if($f =~ /^  .*\(CURLMOPT_/) {
            $c++;
        }
    }
    if(!$c) {
        # check the old style
        foreach $f (@file) {
            if($f =~ /^  CINIT/) {
                $c++;
            }
        }
    }
    return $c;
}

foreach my $t (sort sortthem @releases) {
    if(num($t) <= 70101) {
        next;
    }
    my $d = tag2date($t);
    my @out = `git show $t:include/curl/multi.h 2>/dev/null`;
    my $n = options(@out);
    if($n) {
        print "$d;$n\n";
    }
}

my @out = `git show origin/master:include/curl/multi.h 2>/dev/null`;
my $n = options(@out);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "%04d-%02d-%02d;%d\n", $year + 1900, $mon + 1, $mday, $n;
