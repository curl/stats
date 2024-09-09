#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short  | grep "^CommitDate:"`;

my $total;

for(@a) {
    chomp;
    my $line = $_;
    if(/^CommitDate: (\d\d\d\d)-(\d\d)-(\d\d)/) {
        $date{"$2"}++;
        $total++;
    }
}

my @m = (
    '[none]',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December');

for my $d (sort keys %date) {
    printf "%d;%s %.1f%%;%d\n", $d, $m[$d], $date{$d} * 100 / $total,
        $date{$d};
}
