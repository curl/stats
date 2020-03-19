#!/usr/bin/perl

open(L, "git log --reverse --pretty=fuller --date=short --stat -- docs |");

my $date;
my $lines = 3977;
my $c;
my $hash;

while(<L>) {
    chomp;
    my $line = $_;
    if($line =~ /^CommitDate:([ \t]*)(.*)/) {
        $date = $2;
    }
    elsif($line =~ /^commit ([0-9a-f]+)$/) {
        $hash = $1;
    }
    elsif($line =~ /^ (\d*) file(|s) changed, (.*)/) {
        my $d=$3;
        my $adds=0;
        my $dels=0;

        $d =~ s/, //; #remove comma
        if($d =~ s/(\d*) insertion(s|)\(\+\)//) {
            $adds = $1;
        }
        if($d =~ s/(\d*) deletion(s|)\(\-\)//) {
            $dels = $1;
        }
        $lines += $adds;
        $lines -= $dels;


        if($date =~ /^(\d\d\d\d)-(\d\d)/) {
            $month = "$1-$2";
            $sdate = "$date";
        }

        #if($month < "2010-01") {
        #    next;
        #}

        # new date
        if($sdate ne $ldate) {
            print "$date;$lines\n";
            $ldate = $sdate;
        }
        $c++;
        $date="";
    }
}

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "%04d-%02d-%02d;%d\n", $year + 1900, $mon + 1, $mday, $lines;
