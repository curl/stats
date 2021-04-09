#!/usr/bin/perl


open(G, "git log --reverse --pretty=fuller --no-color --date=short --decorate=full|");

my $author;
while(<G>) {
    chomp;
    $line = $_;
    if($line =~ /^Author: *([^\<]*) \</) {
        $author=$1;
        if($author ne "Daniel Stenberg") {
            $author = "else";
        }
    }
    elsif($line =~ /^CommitDate:([ \t]*)(.*)/) {
        $date = $2;
        if($date =~ /^(\d\d\d\d)-(\d\d)/) {
            $period = "$1-$2";
        }
        $commit{$period}++;
        $commituser{$period.$author}++;
    }
}

my @pp;
my $total;
my $d;
my $r;
for my $y (sort keys %commit) {
    $total += $commit{$y};
    $d += $commituser{$y."Daniel Stenberg"};
    $r += $commituser{$y."else"};
    printf "%s-01;%u;%u;%u\n", $y, $total, $d, $r;
}
