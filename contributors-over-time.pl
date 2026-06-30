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

sub contribs {
    my ($tag) = @_;

    my @file = `git show $tag:RELEASE-NOTES 2>/dev/null`;
    foreach $f (@file) {
        if($f =~ /ontributors: *(\d+)/) {
            return $1;
        }
    }
    return 0;
}

# git show curl-7_8:docs/THANKS | grep -c ' - '
# 67

print <<EARLY
httpget 0.1;1996-11-11;1
httpget 0.2;1996-12-17;2
urlget 3.12;1998-03-14;5
curl 4.8;1998-07-30;7
curl 6.0;1999-09-13;30
curl 7.1.1;2000-08-21;48
curl 7.8;2001-06-07;67
curl 7.9;2001-09-23;73
EARLY
    ;;

foreach my $t (sort sortthem @releases) {
    my $d = tag2date($t);
    my $c = contribs($t);
    if($c) {
        # prettyfy
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        print "$t;$d;$c\n";
    }
}
$t=`git describe --match "curl*"`;
chomp $t;
$c = contribs($t);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "now;%04d-%02d-%02d;%d\n", $year + 1900, $mon + 1, $mday, $c;
