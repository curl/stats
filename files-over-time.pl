#!/usr/bin/perl

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

sub filecount {
    my ($tag)=@_;
    my $count;
    open(G, "git ls-tree -r --name-only $tag 2>/dev/null|");
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
        printf "$d;$c\n";
    }
}
