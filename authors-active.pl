#!/usr/bin/perl
my @a = `git log --use-mailmap --reverse --pretty=fuller --no-color --date=short --decorate=full --since='2015-01-01'  | grep -E "^(Author|CommitDate):"`;

use Time::Piece;

my %dateday;
sub days {
    my ($date) = @_;
    if($dateday{$date}) {
        return $dateday{$date};
    }
    my $d = Time::Piece->strptime($date, "%Y-%m-%d");
    $dateday{$date} = $d;
    return $d;
}

sub delta {
    my ($from, $to) = @_;

    my $f = days($from);
    my $t = days($to);

    my $diff = $t - $f;
    return int($diff->days);
}

my $auth;
my $prev;
my $pline;
for(@a) {
    chomp;
    my $line = $_;
    if(/^Author: *([^\<]*) \</) {
        ($auth)=($1);
        $person{$auth}++;
    }
    elsif(/^CommitDate: (.*)/) {
        my $d = $1;

        $date{$auth}=$d;
        if($d eq $prev) {
            next;
        }
        $prev = $d;
        my $active12;
        my $active9;
        my $active6;
        my $active3;
        my $activew;
        foreach my $p (keys %person) {
            my $de = delta($date{$p}, $d);
            if($de > 120) {
                next;
            }

            $active12++ if($de < 120);
            $active9++ if($de < 90);
            $active6++ if($de < 60);
            $active3++ if($de < 30);
            $activew++ if($de < 7);
        }

        my $line = sprintf "%d;%d;%d;%d;%d",
            $active12, $active9, $active6, $active3, $activew;

        if($line ne $pline) {
            printf "$d;%s\n", $line;
            $pline = $line;
        }
    }
}
