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

sub ncontribs {
    my ($tag)=@_;
    open(G, "git show $tag:RELEASE-NOTES|");
    my @rl = <G>;
    close(G);
    my $c = 0;
    for my $r (@rl) {
        if($r =~ /^ *\((\d+) contributors\)/) {
            $c = $1;
            last;
        }
    }

    if(!$c) {
        # no counter, make our own count
        my $o = 0;
        for my $r (@rl) {
            if($r =~ /friends like these/) {
                $o = 1;
            }
            elsif($o == 1) {
                my @n = split(/, /, $r);
                $c += scalar(@n);
            }
            if($r =~ /Thanks!/) {
                last;
            }
        }
    }

    return $c;
}

sub median {
    my @a = @_;
    my @vals = sort {$a <=> $b} @a;
    my $len = @vals;
    if($len%2) { #odd?
        return $vals[int($len/2)];
    }
    else {
        #even
        return ($vals[int($len/2)-1] + $vals[int($len/2)])/2;
    }
}

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum / scalar(@p);
}

foreach my $t (sort sortthem @releases) {

    if(num($t) < 71008) {
        # no RELEASE-NOTES before 7.10.8
        next;
    }

    my $d = tag2date($t);
    my $c = ncontribs($t);
    if($c) {
        push @pp, $c;
        if(scalar(@pp) > 7) {
            shift @pp;
        }
        # prettyfy
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        printf "$d;$c;%d\n", median(@pp);
    }
}

#$t=`git describe`;
#chomp $t;
#my $c = ncontribs($t);
#push @pp, $c;
#if(scalar(@pp) > 7) {
#    shift @pp;
#}
#my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
#    localtime(time);
#printf "%04d-%02d-%02d;%d;%d\n", $year + 1900, $mon + 1, $mday, $c,
#    median(@pp);
