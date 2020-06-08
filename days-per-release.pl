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

sub median {
    my @a = @_;
    my @vals = sort {$a <=> $b} @a;
    my $len = @vals;
    if($len%2) { #odd?
        return $vals[int($len/2)];
    }
    else {
        #even
        return ($vals[int($len/2)-1] + $vals[int($len/2)])/2;
    }
}


for my $r (reverse @inorder) {
    my $da = days($p, $release{$r});
    push @pp, $da;
    if(scalar(@pp) > 7) {
        shift @pp;
    }
    # skips r, the release version
    printf "%s;%d;%.1f\n", $release{$r}, $da, median(@pp);
    $p = $release{$r};
}
