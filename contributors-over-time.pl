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
            # strip off the time zone and time
            $d = "$1";
            last;
        }
    }
    close(G);
    return $d;
}

sub options {
    my @file = @_;

    foreach $f (@file) {
        if($f =~ /curl_easy_setopt\(\) options: *(\d+)/) {
            return $1;
        }
    }
    return 0;
}

sub loc {
    my ($tag) = @_;
    `git checkout -f $tag 2>/dev/null`;
    my @wc = `find lib include src -name "*.[ch]" | xargs wc -l`;
    return int($wc[$#wc]);
}

sub contribs {
    my @file = @_;

    foreach $f (@file) {
        if($f =~ /ontributors: *(\d+)/) {
            return $1;
        }
    }
    return 0;
}

foreach my $t (sort sortthem @releases) {
    my $d = tag2date($t);
    my @out = `git show $t:RELEASE-NOTES 2>/dev/null`;
    #my $n = options(@out);
    my $c = contribs(@out);
    if($c) {
        # prettyfy
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        print "$t;$d;$c;$loc\n";
    }
}
