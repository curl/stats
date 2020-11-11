#!/usr/bin/perl

open(L, "git log --reverse --pretty=fuller --date=short --stat|");

my $lines;

my $month;

while(<L>) {
    chomp;
    my $line = $_;
    # store the date first
    if($line =~ /^Author:([ \t]*)(.*) \</) {
        $author = $2;
        if($author ne "Daniel Stenberg") {
            $author="others";
        }
        $all{$author}++;
    }
    elsif($line =~ /^CommitDate:([ \t]*)(.*)/) {
        my $date = $2;

        if($date =~ /^(\d\d\d\d)-(\d\d)/) {
            $month = "$1-$2";
        }
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

        $add{$author.$month} += $adds;
        $rem{$author.$month} += $dels;
        $when{$month}++;
    }
}
my $ddels, $dadds;
my $oadds, $odels;
my $lines;
for my $date (sort keys %when) {
    $ddels += $rem{"Daniel Stenberg".$date};
    $dadds += $add{"Daniel Stenberg".$date};
    $odels += $rem{"others".$date};
    $oadds += $add{"others".$date};
    $lines = $dadds + $oadds - $ddels - $odels;
    printf "$date-01;%d;%d;%d;%d;%d\n", $dadds, $oadds, $ddels, $odels, $lines;
}
