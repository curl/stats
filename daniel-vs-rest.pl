#!/usr/bin/perl

my $c=0;

open(G, "git log --reverse --pretty=fuller --no-color --date=short --decorate=full --stat|");

while(<G>) {
    chomp;
    my $line = $_;
    if($line =~ /^CommitDate: (\d\d\d\d-\d\d)/) {
        $date = $1; # year + month
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

        #print STDERR "$date $author += $lines\n";
        $add{$author, $date} += $adds;
        $del{$author, $date} += $dels;
    }
}
close(G);

for my $date (sort keys %when) {
    #print STDERR "$date: $when{$date}\n";
    $alld += $commit{"Daniel Stenberg", $date};
    $alltot += $when{$date};

    $dadd += $add{"Daniel Stenberg", $date};
    $alladd += $add{"Daniel Stenberg", $date} +
        $add{"else", $date};
    my $addshare = 100;
    $addshare = $dadd / $alladd * 100 if($alladd);

    $ddel += $del{"Daniel Stenberg", $date};
    $alldel += $del{"Daniel Stenberg", $date} +
        $del{"else", $date};
    my $delshare = 100;
    $delshare = $ddel / $alldel * 100 if($alldel);

    printf "$date-01;%.2f;%.2f;%.2f;%.2f;%.2f\n",
        ($alld/$alltot * 100),
        100 - ($alld/$alltot * 100),
        $commit{"Daniel Stenberg", $date}/$when{$date} * 100,
        $addshare, $delshare;
}
