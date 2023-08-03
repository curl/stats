#!/usr/bin/perl

require "./stats/tag2date.pm";

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

sub filecount {
    my ($tag, $pref)=@_;
    my $count;
    open(G, "git ls-tree -r --name-only $tag -- $pref 2>/dev/null|");
    my @file=<G>;
    close(G);
    return scalar(@file);
}


my @this = sort sortthem @releases;

my $now = `git describe`;
chomp $now;

# top off with the current state
push @this, $now;

foreach my $t (@this) {

    my $c = filecount($t);
    my $testsonly = filecount($t, "tests");

    if($c) {
        # prettify
        my $d;
        my $d = tag2date($t);
        if($t ne $now) {
            $t =~ s/_/./g;
            $t =~ s/-/ /g;
        }
        else {
            $t = "now";
        }
        printf "$d;$c;%u\n", $c-$testsonly;
    }
}
