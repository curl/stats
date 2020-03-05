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

sub tests {
    my ($tag) = @_;
    `git checkout -f $tag 2>/dev/null`;
    my @wc = `git ls-files "tests/data/test*" | wc -l`;
    return int($wc[$#wc]);
}


foreach my $t (sort sortthem @releases) {
    my $d = tag2date($t);
    my $l = tests($t);

    # prettyfy
    $t =~ s/_/./g;
    $t =~ s/-/ /g;
    print "$t;$d;$l\n";
}
