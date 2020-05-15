#!/usr/bin/perl

open(L, "git log --reverse --pretty=fuller --date=short --stat -- src lib include |");

my $date;
my %lines;
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
        if($date =~ /^(\d\d\d\d)-(\d\d)/) {
            $month = "$1-$2-01";
        }

        $lines{$month} += $adds;
        $lines{$month} -= $dels;
    }
}

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $lines{$y};
    }
    return $sum / scalar(@p);
}

my @pp;
my $total;
for my $l (sort {$a cmp $b} keys %lines) {
    $total += $lines{$l};
    push @pp, $l;
    if(scalar(@pp) > 12) {
        shift @pp;
    }
    printf "%s;%d;%.1f;%.4f,%d\n", $l, $lines{$l}, average(@pp),
        average(@pp)*100/$total, $total;
}
