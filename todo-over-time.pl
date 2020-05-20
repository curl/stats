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
    my ($tag, $file) = @_;
    my @t = `git show $tag:$file 2>/dev/null`;
    my $c =0;
    if(num($tag) < 71800) {
        # before 7.18.0 TODO was different
        foreach $l (@t) {
            if($l =~ /^ \* /) {
                $c++;
            }
        }
    }
    if(num($tag) < 71300) {
        # known bugs before 7.13.0
        foreach $l (@t) {
            if($l =~ /^\* /) {
                $c++;
            }
        }
    }
    elsif(num($tag) < 74900) {
        # before 7.49.0 KNOWN_BUGS was different
        foreach $l (@t) {
            if($l =~ /^\d+\. /) {
                $c++;
            }
        }
    }

    foreach $l (@t) {
        if($l =~ /^\d+\.\d+/) {
            $c++;
        }
    }
    return $c;
}

foreach my $t (sort sortthem @releases) {
    my $d = tag2date($t);
    my $n = options($t, "docs/TODO");
    my $k = options($t, "docs/KNOWN_BUGS");
#    my $c = contribs(@out);
#    my $loc = loc($t);

    if($n || $k) {
        # prettyfy
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        print "$d;$n;$k\n";
    }
}

$t=`git describe`;
chomp $t;

my $n = options($t, "docs/TODO");
my $k = options($t, "docs/KNOWN_BUGS");
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
$date = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
print "$date;$n:$k\n";
