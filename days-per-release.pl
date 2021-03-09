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
    my $delta = int(($secs-$psecs)/86400);
    return $delta;
}

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum / scalar(@p);
}

for my $r (reverse @inorder) {
    my $now = $release{$r};
    my $delta = days($p, $now);
    push @pp, $delta;
    push @ppall, $delta;
    push @da, $now;

    while(days($da[0], $now) > 365) {
        shift @pp;
        shift @da;
    }
    printf "%s;%d;%.1f;%.1f\n", $now, $delta, average(@pp), average(@ppall);
    $p = $now;
}
