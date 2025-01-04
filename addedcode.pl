#!/usr/bin/perl

open(G, "git log --reverse --stat --date=short --pretty=\"Date: %cd\" -- src lib include 2>/dev/null|");
my $date;
my $lines;
my $pdate;

sub display {
    my ($d)=@_;
    if(!$pdate) {
        $pdate = $d;
    }
    elsif($d ne $pdate) {
        printf "$pdate;$lines;%d\n", $l{$pdate};
        $pdate = $d;
    }
}

while(<G>) {
    if(/^Date: *(\d\d\d\d-\d\d-\d\d)/) {
        $date = $1;
    }
    if(/changed, (\d*) insertion/) {
        if(!$date) {
            die "bad: $1";
        }
        $l{$date} += $1;
        display($date);
        $lines += $1;
        undef $date;
    }
    chomp;
}
close(G);
