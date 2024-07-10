#!/usr/bin/perl

my $c=0;

open(G, "git log --reverse --pretty=fuller --no-color --date=short|");

while(<G>) {
    chomp;
    my $line = $_;
    if($line =~ /^Commit: *([^\<]*) \</) {
        $author=$1;
        if($author ne "Daniel Stenberg") {
            $author = "else";
        }
        $uniq{$author}++;
    }
    elsif($line =~ /^CommitDate: (\d\d\d\d-\d\d)/) {
        $date = $1; # year + month
        $commit{$author,$date}++;
        $total{$author}++;
        $when{$date}++;
        $c++;
    }
}
close(G);

for my $date (sort keys %when) {
    #print STDERR "$date: $when{$date}\n";
    $alld += $commit{"Daniel Stenberg", $date};
    $alltot += $when{$date};

    printf "$date-01;%.2f;%.2f\n",
        ($alld/$alltot * 100),
        $commit{"Daniel Stenberg", $date}/$when{$date} * 100;
}
