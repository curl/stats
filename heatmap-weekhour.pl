#!/usr/bin/perl
my @a= `TZ=UTC git log --oneline --date='format-local:%w %H' --decorate --format='format:%ad'`;

my @commit;
my $count;
for(@a) {
    chomp;
    my $line = $_;
    my ($d, $h)=split(/ /, $line);
    $d = 7 if(!$d);
    $commit[$d][$h]++;
    $count++;
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

printf STDERR "Hours: %u, commits: %d\n", scalar(@allhours), $count;

for my $e (0 .. 4) {
    printf STDERR "LEVEL $e: %u\n", $levels[$e];
}

sub level {
    my ($l, @levels) = @_;
    for my $e (0 .. 4) {
        if($l <= $levels[$e]) {
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
