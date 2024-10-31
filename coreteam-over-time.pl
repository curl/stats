#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full  | grep -E "^(Author|CommitDate):"`;

my $year=1999;
for(@a) {
    chomp;
    my $line = $_;
    if(/^CommitDate: (\d\d\d\d)/) {
        $year = $1;
    }
    if(/^Author: *([^\<]*) \</) {
        my ($auth)=($1);
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

# iterate over all authors, count those who did less than three that year
for my $a (sort keys %total) {
    for my $y (sort keys %years) {
        #print STDERR "check $a for $y\n";
        if($uniqyear{$a.$y} && ($uniqyear{$a.$y} < 3)) {
            $driveby{$y}++;
        }
        if($uniqyear{$a.$y} && ($uniqyear{$a.$y} > 9)) {
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

for my $y (sort keys %years) {
    my @a = split(/;/, $tenner[$y]);
    my $coretotal;
    my @list;
    foreach my $a (sort {$uniqyear{$b.$y} <=> $uniqyear{$a.$y}} @a) {
        my $l;
        my $combo = 0;
        if($firstyear{$a} == $y) {
            $l.=" (newcomer)";
            $combo |= 1;
        }
        elsif(!$core[$y-1]{$a}) {
            $l=" (back from break)";
        }
        if($lastyear{$a} == $y) {
            if(($combo == 1) && ($firstyear{$a} != $y)) {
                $l=" (single year)";
            }
            elsif($y != $lastyear) {
                $l.=" (final year)";
            }
        }
        elsif(!$core[$y+1]{$a}) {
            $l=" (before break)";
        }

        push @list, sprintf "$y - %s %d commits (%.1f%%)$l\n  ", $a, $uniqyear{$a.$y}, $uniqyear{$a.$y} * 100 / $years{$y};

        $coretotal += $uniqyear{$a.$y};
    }
    printf "$y (%d core authors, %.1f%% of total commits, %d of %d)\n  ",
        scalar(@a),
        $coretotal*100 / $years{$y},
        $coretotal, $years{$y};
    print @list;
    print "\n";
}

for my $a (keys %tenagain) {
    $alltens += $tenagain{$a};
}

my @ss = sort {$tenagain{$b} <=> $tenagain{$a} } keys %tenagain;

printf "All time (%d authors, average %.1f years, median %d year)\n  ",
    scalar(keys %tenagain), $alltens/scalar(keys %tenagain),
    $tenagain{$ss[$#ss/2]};

my $i=1;
for my $a (@ss) {
   #printf "%s (%d): %s\n  ", $a, $tenagain{$a}, $tenyears{$a};
   printf "%2d: %s (%d years)\n  ", $i++, $a, $tenagain{$a};
}
