#!/usr/bin/perl

# WARNING!
#
# This script does actual 'git checkouts' of the code from the tags to get the
# numbers.
#

sub num {
    my ($t)=@_;
    if($t =~ /^curl-(\d)_(\d+)_(\d+)/) {
        return 10000*$1 + 100*$2 + $3;
    }
    elsif($t =~ /^curl-(\d)_(\d+)/) {
        return 10000*$1 + 100*$2;
    }
}


sub sortthem {
    return num($a) <=> num($b);
}

@alltags= `git tag -l`;

foreach my $t (@alltags) {
    chomp $t;
    if($t =~ /^curl-([0-9_]*[0-9])\z/) {
        push @releases, $t;
    }
}

sub tag2date {
    my ($t)=@_;
    open(G, "git show $t --pretty=\"Date: %ci\" -s 2>/dev/null|");
    my $d;
    while(<G>) {
        if($_ =~ /^Date: (\d+-\d+-\d+) (\d+:\d+:\d+)/) {
            # strip off the time and time zone
            $d = "$1";
            last;
        }
    }
    close(G);
    return $d;
}

sub counttests {
    my @wc = `git ls-files "tests/data/test*" | wc -l`;
    return int($wc[$#wc]);
}

sub tests {
    my ($tag) = @_;
    `git checkout -f $tag 2>/dev/null`;
    return counttests();
}


foreach my $t (sort sortthem @releases) {
    my $d = tag2date($t);
    my $l = tests($t);

    # prettyfy
    $t =~ s/_/./g;
    $t =~ s/-/ /g;
    print "$t;$d;$l\n";
}

# restore
`git checkout -q master`;

# repeat the last line with current date
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
my $date = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
printf "now;$date;%d\n", counttests();
