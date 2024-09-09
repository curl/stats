#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=format:%A  | grep "^CommitDate:"`;

my $total;
for(@a) {
    chomp;
    my $line = $_;
    if(/^CommitDate: (.*)/) {
        $date{"$1"}++;
        $total++;
    }
}

my @m = (
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
    );

for my $d (0 .. 6) {
    printf "%d;%s %.1f%%;%d\n", $d, $m[$d], $date{$m[$d]} * 100/ $total,
        $date{$m[$d]};
}
