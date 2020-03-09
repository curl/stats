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

sub readme2apicount {
    my ($tag)=@_;
    open(G, "git show $tag:RELEASE-NOTES|");
    my $c = 0;
    while(<G>) {
        if($_ =~ /^ Public functions in libcurl: *(\d+)/) {
            $c = $1;
            last;
        }
    }
    close(G);
    return $c;
}

# 7.16.0 bumped the SONAME to 4
print <<MOO
curl 7.1.1;2000-08-21;31
curl 7.13.0;2005-02-01;46
curl 7.14.0;2005-05-16;46
curl 7.15.0;2005-10-13;46
curl 7.15.2;2006-02-27;46
curl 7.15.3;2006-03-20;46
curl 7.15.4;2006-06-12;48
curl 7.15.5;2006-08-07;54
curl 7.16.0;2006-10-30;54
curl 7.16.1;2007-01-29;54
curl 7.16.3;2007-06-25;55
curl 7.17.0;2007-09-13;55
MOO
    ;

foreach my $t (sort sortthem @releases) {

    if(num($t) < 71300) {
        # before 7.13.0 we can't easily grep
        next;
    }

    my $d = tag2date($t);
    my $c = readme2apicount($t);
    if($c) {
        # prettyfy
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        print "$t;$d;$c\n";
    }
}
