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
        if($date =~ /(\d\d\d\d)-/) {
            my $year = $1;
            $release{$year}++;
        }
        push @inorder, $version;
        $p = $date; # remmeber the last date, which is the earliest
    }
    close(C);
}

buginfo();

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum / scalar(@p);
}

for my $r (sort keys %release) {
    push @app, $release{$r};
    push @pp, $release{$r};
    if(scalar(@pp) > 5) {
        shift @pp;
    }
    printf "%s;%d;%.2f;%.2f\n", $r, $release{$r}, average(@pp), average(@app);
}
