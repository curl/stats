#!/usr/bin/perl
my @a = `git log --no-color --date=unix`;

# This lists all commits showing the author date in UTC epoch time.

# return day + hour
# day is oddly 1 for Monday and 7 for Sunday
sub epoch2daytime {
    my ($ep) = @_;
   # print STDERR "EP: $ep\n";
   # print STDERR "cmd: date -ud \@$ep \"+%u %H\"\n";
    my $o = `date -ud \@$ep "+%u %H"`;
    my ($d, $h) = split(/ /, $o);
    return (0 + $d), (0 + $h);
}

my @commit;
for(@a) {
    chomp;
    my $line = $_;
    if($line =~ /^Date: *(\d+)/) {
        my ($d, $h) = epoch2daytime($1);
        $commit[$d][$h]++;
        #printf "IN: %d,%d,%d\n", $d, $h, $commit{$d, $h};
    }
}

my @allhours;
for my $d (1 .. 7) {
    for my $h (0 .. 23) {
        push @allhours, $commit[$d][$h];
    }
}

my @levels;

my @sall = sort { $a <=> $b } @allhours;

$levels[0] = $sall[168/10];    # p10
$levels[1] = $sall[168/5];     # p20
$levels[2] = $sall[168/5 * 2]; # p40
$levels[3] = $sall[168/5 * 3]; # p60
$levels[4] = $sall[168/5 * 4]; # p80

for my $e (0 .. 4) {
    printf STDERR "LEVEL $e: %u\n", $levels[$e];
}

sub level {
    my ($l, @levels) = @_;
    for my $e (0 .. 4) {
        if($l < $levels[$e]) {
            return $e;
        }
    }
    return 5;
}

for my $h (0 .. 23) {
    for my $d (1 .. 7) {
        printf "%d,%d,%d\n", $h, $d, level($commit[$d][$h], @levels);
    }
}
