#!/usr/bin/perl

require "./stats/average.pm";

my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full  | grep -E "^(Author|CommitDate):"`;

my $percent = 80;
$percent = $ARGV[0] if($ARGV[0]);

my $year=2000;
for(@a) {
    chomp;
    my $line = $_;
    if(/^CommitDate: (\d\d\d\d)/) {
        $year = $1;
    }
    if(/^Author: *([^\<]*) \</) {
        my ($auth)=($1);
        if($year < 2000) {
            next;
        }
        $uniq{$auth}++;
        $uniqyear{$auth.$year}++;
        $total{$auth}++;
        $years{$year}++;
        if($uniq{$auth} == 1) {
            # this many did their first commit this year
            $when{$year}++;
        }
        if($uniqyear{$auth.$year} == 1) {
            # total count of authors this year
            $whenyear{$year}++;
        }
    }
}

for my $a (sort keys %total) {
    for my $y (sort keys %years) {
        #print STDERR "check $a for $y\n";
        if($uniqyear{$a.$y}) {
            $tenmore{$y}++;
            $tenner[$y] .= "$a;";
            $tenagain{$a}++;
            $tenyears{$a} .= "$y, ";
        }
    }
}

for my $y (sort keys %years) {
    my @a = split(/;/, $tenner[$y]);
    foreach my $a (@a) {
        $core[$y]{$a}=1;
        $lastyear{$a}=$y;
        if(!$firstyear{$a}) {
            $firstyear{$a}=$y
        }
        #print STDERR "set $y $a to 1\n";
    }
    $lastyear = $y;
}

my @pp;
for my $y (sort keys %years) {
    my @a = split(/;/, $tenner[$y]);
    my @list;
    my $limit = $percent;
    foreach my $a (sort {$uniqyear{$b.$y} <=> $uniqyear{$a.$y}} @a) {

        my $perc = $uniqyear{$a.$y} * 100 / $years{$y};
        push @list, sprintf "$y - %s %d commits (%.1f%%)$l\n  ", $a,
            $uniqyear{$a.$y}, $perc;

        $limit -= $perc;
        if($limit <= 0) {
            last;
        }
    }
    push @pp, scalar(@list);
    if(scalar(@pp) > 5) {
        shift @pp;
    }
    push @alltime, scalar(@list);

    # count for all years from 2000 until this year
    my $totcommits;
    my %totauth;
    for my $y2 (2000 .. $y) {
        $totcommits += $years{$y2};
        foreach my $auth (keys %uniq) {
            $totauth{$auth} += $uniqyear{$auth.$y2};
        }
    }

    my $share = $percent;
    for my $t (sort {$totauth{$b} <=> $totauth{$a}} keys %uniq) {
        #printf "  $t: %s\n", $totauth{$t};
        $share -= $totauth{$t} * 100 / $totcommits;
        if($share <= 0) {
            last;
        }
    }


    printf "$y-01-01;%u;%.2f;%.2f\n",
        scalar(@list), average(@pp), average(@alltime);
}
