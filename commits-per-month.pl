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

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $commit{$y};
    }
    return $sum / scalar(@p);
}

my @pp;
for my $y (sort keys %commit) {
    push @pp, $y;
    push @ppall, $y;
    if(scalar(@pp) > 12) {
        shift @pp;
    }
    printf "%s-01;%d;%.2f;%.2f\n", $y, $commit{$y}, average(@pp), average(@ppall);
}
