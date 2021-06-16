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
        if($period >= 2000) {
            $commit{$period}++;
        }
    }
}

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $commit{$y};
    }
    return $sum / scalar(@p);
}

for my $y (sort keys %commit) {
    push @l, $y;
    if(scalar(@l) > 5) {
        shift @l;
    }
    printf "%s-01-01;%d;%.1f\n", $y, $commit{$y}, average(@l);
}
