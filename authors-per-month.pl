#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full | egrep "^(Author|CommitDate):"`;

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

#print "Month; First Commit; Unique Authors; Drive-by; Total uniques\n";
for my $y(sort keys %whenmonth) {
    if($y > 2009) {
        printf("%s;%d;%d;%d;%d\n",
               $y, $when{$y}, $whenmonth{$y}, $driveby{$y}, $uniqs{$y});
    }
}
