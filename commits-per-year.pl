#!/usr/bin/perl


open(G, "git log --reverse --pretty=fuller --no-color --date=short --decorate=full|");

while(<G>) {
    chomp;
    $line = $_;
    if($line =~ /^CommitDate:([ \t]*)(.*)/) {
        $date = $2;
        if($date =~ /^(\d\d\d\d)-(\d\d)/) {
            $period = "$1";
        }
        $commit{$period}++;
    }
}

for my $y (sort keys %commit) {
    printf "%s-01-01;%d\n", $y, $commit{$y};
}
