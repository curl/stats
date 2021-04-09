#!/usr/bin/perl


open(G, "git log --reverse --pretty=fuller --no-color --date=short --decorate=full|");

while(<G>) {
    chomp;
    $line = $_;
    if($line =~ /^CommitDate:([ \t]*)(.*)/) {
        $date = $2;
        if($date =~ /^(\d\d\d\d)-(\d\d)/) {
            $period = "$1-$2";
        }
        $commit{$period}++;
    }
}

my @pp;
my $total;
for my $y (sort keys %commit) {
    $total += $commit{$y};
    printf "%s-01;%d\n", $y, $total;
}
