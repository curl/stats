#!/usr/bin/perl

my $c=0;

open(G, "git log --reverse --pretty=fuller --no-color --date=short --decorate=full|");

while(<G>) {
    chomp;
    my $line = $_;
    if($line =~ /^CommitDate: (\d\d\d\d-\d\d)/) {
        my $date = $1; # year + month
        $commit{$author,$date}++;
        $total{$author}++;
        $when{$date}++;
        $c++;
    }
    elsif($line =~ /^Author: *([^\<]*) \</) {
        $author=$1;
        if($author ne "Daniel Stenberg") {
            $author = "else";
        }
        $uniq{$author}++;
    }
}
close(G);

for my $date (sort keys %when) {
    $alld += $commit{"Daniel Stenberg", $date};
    $alltot += $when{$date};
    printf "$date-01;%.2f;%.2f;%.2f\n",
        ($alld/$alltot * 100),
        100 - ($alld/$alltot * 100),
        $commit{"Daniel Stenberg", $date}/$when{$date} * 100;
}
