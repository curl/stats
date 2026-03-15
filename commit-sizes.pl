#!/usr/bin/perl

# - single file commit
# - single line changed (one add, one remove)
# - > 5 files changed
# - > 50 lines delta
# - > 20 and > 50 lines changed

open(G, "git log --reverse --pretty=fuller --no-color --date=short --decorate=full --stat|");

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

sub percentone {
    my (@nums) = @_;
    if(scalar(@nums)) {
        my $single = grep {$_ == 1 } @nums;
        return $single * 100 / scalar(@nums);
    }
    else {
        return 0;
    }
}

sub equal_or_more {
    my ($limit, @nums) = @_;
    if(scalar(@nums)) {
        my $single = grep { $_ >= $limit } @nums;
        return $single * 100 / scalar(@nums);
    }
    else {
        return 0;
    }
}

my $span = 365;

my $date;
my $pdate;
while(<G>) {
    chomp;
    my $line = $_;
    if($line =~ /^CommitDate: (.*)/) {
        $date = $1;
        if($pdate ne $date) {
            printf "$pdate;%.1f;%.1f;%.1f;%.1f;%.1f;%.1f\n",
                percentone(@filenum),   # single file edit
                percentone(@singledit), # single line edit
                equal_or_more(5, @filenum),
                equal_or_more(50, @delta),
                equal_or_more(20, @linesmod),
                equal_or_more(50, @linesmod) if($pdate);
            $pdate = $date;
        }
    }
    if($line =~ /^ (\d+) file/) {
        my $add = 0;
        my $del = 0;
        my $max;

        if($line =~ /, (\d+) insertion/) {
            $add = $1;
        }
        if($line =~ /, (\d+) deletion/) {
            $del = $1;
        }

        while($commitdate[0] && delta($commitdate[0], $date) > $span) {
            # shift off all the bad dates
            shift @commitdate;
            shift @filenum;
            shift @singledit;
            shift @delta;
            shift @linesmod;
        }

        push @filenum, $1;
        push @commitdate, $date;

        $max = $add;
        if($del > $max) {
            $max = $del
        }
        $add -= $del;
        if(!$add && ($del == 1)) {
            push @singledit, 1;
        }
        else {
            # not 1
            push @singledit, 2;
        }
        push @delta, $add;
        push @linesmod, $max;
    }
}
close(G);

# The script never emits a line for the last commit date, but having a single
# day off should be fine.
