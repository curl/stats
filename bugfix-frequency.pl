#!/usr/bin/perl

# NOTE: uses the curl-www repo for input!

my $webroot = $ARGV[0] || "../curl-www";
$csv = "$webroot/docs/releases.csv";

my %release;
my @inorder;

my $p;

sub buginfo {
    open(C, "<$csv");
    while(<C>) {
        chomp;
        my ($index, $version, $vulns, $date, $since, $ddays, $adays, $dbugs, $abugs,
            $dchanges, $achanges) = split(';', $_);
        $release{$version}=$date;
        $dfixes{$version}=$dbugs; # fixed in this release
        $afixes{$version}=$abugs; # fixed since the latest release, including this
        $age{$version}=$adays; # days since latest release
        $dage{$version}=$ddays; # days since latest release
        push @inorder, $version;
        $p = $date; # remmeber the last date, which is the earliest
    }
    close(C);
}

buginfo();

sub days {
    my ($prev, $date) = @_;
    my $psecs = `date +%s -d "$prev"`;
    my $secs = `date +%s -d "$date"`;
    return int(($secs-$psecs)/86400);
}


# compare this many releases back
my $delta = 5;

my $addup = 0;

my $firstrel = $inorder[ $#inorder ];

my @sorder = reverse @inorder;

sub sum {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum;
}

for my $i (0 .. $#sorder) {
    my $r = $sorder[$i];
    my $compare = $i;

    $addup += $dfixes{$r};

    push @dv, $dfixes{$r};
    push @da, $release{$r};

    # keep the array less than one year
    while(days($da[0], $release{$r}) > 365) {
        shift @dv;
        shift @da;
    }
    # get the age range
    my $age = days($da[0], $release{$r});

    # bugfixes within the range
    my $bugs = sum(@dv);

    my $bugsperday = $bugs / ($age ? $age : 1);
    #print "bugs: $bugs ($afixes{$compver} - $afixes{$r}) / age: $age ($compver vs $r)\n";
    printf "%s;%d;%.3f\n", $release{$r}, $addup, $bugsperday;
}
