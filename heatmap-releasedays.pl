#!/usr/bin/perl

# NOTE: uses the curl-www repo for input!

my $webroot = $ARGV[0] || "../curl-www";
$csv = "$webroot/docs/releases.csv";

my %release;

sub dayofweek {
    my ($d) = @_;
    my $num = `date -d "$d" +%u`; # 1=Mon..7=Sun
    return 0 + $num;
}

sub weekno {
    my ($d) = @_;
    my $num = `date -d "$d" +%V`; # ISO week 1 .. 53
    return 0 + $num;
}

sub counter {
    open(C, "<$csv");
    while(<C>) {
        chomp;
        my ($index, $version, $vulns, $date, $since, $ddays, $adays, $dbugs, $abugs,
            $dchanges, $achanges) = split(';', $_);
        my $week = weekno($date);
        my $day = dayofweek($date);
        $release{$week, $day}++;
    }
    close(C);
}

counter();

# iterate over weeks
for my $w (1 .. 53) {
    # iterate over days
    for my $d (1 .. 7) {
        my $c = $release{$w, $d};
        if($c) {
            print "$w,$d,$c\n";
        }
    }
}

