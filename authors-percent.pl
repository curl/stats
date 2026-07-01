#!/usr/bin/perl

require "./stats/average.pm";

my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full  | grep -E "^(Author|CommitDate):"`;

my $percent = $ARGV[0] || 90;

sub amount {
    my $share;
    my $count = 1;
    for my $a (sort {$uniq{$b} <=> $uniq{$a}} keys %uniq) {
        $share += $uniq{$a} * 100 / $total;
        #printf "%s: %u (%u%%)\n", $a, $uniq{$a}, $share;
        if($share > $percent) {
            last;
        }
        $count++;
    }
    return $count;
}

my $pa;
my $date;
for(@a) {
    chomp;
    my $line = $_;
    if(/^CommitDate: (\d\d\d\d-\d\d-\d\d)/) {
        $date = $1;
        my $a = amount();
        if($a != $pa) {
            printf "$date;%u\n", $a;
            $pa = $a;
        }
    }
    if(/^Author: *([^\<]*) \</) {
        my ($auth)=($1);
        $total++;
        $uniq{$auth}++;
    }
}
print "$date;$pa\n";
