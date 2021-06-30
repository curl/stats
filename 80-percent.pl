#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full  | egrep "^(Author|CommitDate):"`;

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

# iterate over all authors, count those who did less than three that year
for my $a (sort keys %total) {
    for my $y (sort keys %years) {
        #print STDERR "check $a for $y\n";
        if($uniqyear{$a.$y} && ($uniqyear{$a.$y} < 3)) {
            $driveby{$y}++;
        }
        if($uniqyear{$a.$y} && ($uniqyear{$a.$y} > 2)) {
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

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum / scalar(@p);
}

my @pp;
for my $y (sort keys %years) {
    my @a = split(/;/, $tenner[$y]);
    my $coretotal;
    my @list;
    my $limit = 80;
    foreach my $a (sort {$uniqyear{$b.$y} <=> $uniqyear{$a.$y}} @a) {

        my $perc = $uniqyear{$a.$y} * 100 / $years{$y};
        push @list, sprintf "$y - %s %d commits (%.1f%%)$l\n  ", $a,
            $uniqyear{$a.$y}, $perc;

        $coretotal += $uniqyear{$a.$y};
        $limit -= $perc;
        if($limit <= 0) {
            last;
        }
    }
    push @pp, scalar(@list);
    if(scalar(@pp) > 5) {
        shift @pp;
    }
    printf "$y-01-01;%u;%.2f\n", scalar(@list), average(@pp);
}
