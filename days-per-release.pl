#!/usr/bin/perl

# NOTE: uses the curl-www repo for input!

my %release;
my @inorder;

my $p;

sub nicedate {
    my ($d) = @_;
    my $n = `date +%F -d "$d"`;
    chomp $n;
    return $n;
}

open(R, "<../curl-www/_changes.html") ||
    die "no web repo";

while(<R>) {
    if(/^SUBTITLE\(Fixed in ([0-9.]+) - ([^)]+)\)/) {
        my $ver = $1;
        my $n = nicedate($2);
        $release{$ver}=$n;
        push @inorder, $ver;
        $p = $n; # remmeber the last, which is the earliest
    }
}

sub days {
    my ($prev, $date) = @_;
    my $psecs = `date +%s -d "$prev"`;
    my $secs = `date +%s -d "$date"`;
    return int(($secs-$psecs)/86400);
}

for my $r (reverse @inorder) {
    my $da = days($p, $release{$r});
    printf "%s;%s;%d\n", $r, $release{$r}, $da;
    $p = $release{$r};
}
