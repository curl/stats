#!/usr/bin/perl

# Convert average and median ages to dates in the past

my $csv = $ARGV[0];

my $average;
my $median;

open(F, "<$csv") or die "can't open";
while(<F>) {
    my $l = $_;
    my @a = split(/;/, $l);
    $average = $a[5];
    $median = $a[6];
}
close(F);

# This gets the times in *years*.

#print "$median $average\n";

my $meddays = int($median * 365.25);
my $avdays = int($average * 365.25);
#printf "%u %u days\n", $meddays, $avdays;

my $m = `date -d "$meddays days ago" +"%Y-%m-%d"`;
my $a= `date -d "$avdays days ago" +"%Y-%m-%d"`;

chomp $m;
chomp $a;

print "$m;$a\n";
