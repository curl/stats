#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full | grep -E "^(Author|CommitDate):"`;

my $c=1;
my $auth="";
for(@a) {
    chomp;
    my $line = $_;
    if(/^Author: *([^\<]*) \</) {
        ($auth)=($1);
    }
    elsif($auth && /^CommitDate: (.*)/) {
        if($1 =~ /^(\d\d\d\d)-(\d\d)/) {
            $month = "$1-$2-01";
        }
        $uniq{$auth}++;
        $uniqs{$month} = scalar(keys %uniq);
        $uniqmonth{$auth.$month}++;
        $total{$auth}++;
        if($uniq{$auth} == 1) {
            # this many did their first commit this month
            $when{$month}++;
        }
        if($uniqmonth{$auth.$month} == 1) {
            # total count of authors this month
            $whenmonth{$month}++;
        }
        #printf "$c;%d\n", scalar(keys %uniq) if(!($c % 50));
        $c++;
        $auth="";
    }
}

# iterate over all authors, count those who did less than three that month
for my $a (sort keys %total) {
    for my $y (sort keys %when) {
        #print STDERR "check $a for $y\n";
        if($uniqmonth{$a.$y} && ($uniqmonth{$a.$y} < 3)) {
            $driveby{$y}++;
        }
    }
}

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $whenmonth{$y};
    }
    return $sum / scalar(@p);
}


my @pp;
#print "Month; Unique Authors;
for my $y(sort keys %whenmonth) {
    if($y > 2009) {
        push @pp, $y;
        if(scalar(@pp) > 12) {
            shift @pp;
        }
        printf("%s;%d;%.2f\n",
               $y, $whenmonth{$y}, average(@pp));
    }
}
