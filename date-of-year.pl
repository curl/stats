#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short  | grep "^CommitDate:"`;

for(@a) {
    chomp;
    my $line = $_;
    if(/^CommitDate: (\d\d\d\d)-(\d\d)-(\d\d)/) {
        $date{"$2-$3"}++;
    }
}

for my $d (sort keys %date) {
    printf "$d;%d\n", $date{$d};
}
