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
2000-08-21;31
2005-02-01;46
2005-05-16;46
2005-10-13;46
2006-02-27;46
2006-03-20;46
2006-06-12;48
2006-08-07;54
2006-10-30;54
2007-01-29;54
2007-06-25;55
2007-09-13;55
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
        print "$d;$c\n";
    }
}

$t=`git describe`;
chomp $t;
my $c = readme2apicount($t);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "%04d-%02d-%02d;%d\n", $year + 1900, $mon + 1, $mday, $c;
