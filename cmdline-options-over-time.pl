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

sub options {
    my @file = @_;

    foreach $f (@file) {
        if($f =~ /ommand line options: *(\d+)/) {
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

print <<MOO
httpget 1.3;1997-06-01;2
urlget 2.4;1997-08-27;9
urlget 3.12;1998-03-14;21
curl 4.0;1998-03-20;24
curl 4.8;1998-08-27;29
curl 5.9;1999-05-22;46
curl 6.0;1999-09-13;48
curl 6.5.2;2000-03-21;48
curl 7.1.1;2000-08-21;48
curl 7.3;2000-09-28;52
curl 7.4.1;2000-10-16;52
curl 7.5;2000-12-01;54
curl 7.6;2001-01-26;54
curl 7.7;2001-03-22;58
curl 7.8;2001-06-07;58
curl 7.9;2001-09-23;62
curl 7.9.3;2002-01-23;70
curl 7.9.8;2002-06-13;76
curl 7.10;2002-10-01;79
curl 7.10.6;2003-07-28;89
MOO
    ;

foreach my $t (sort sortthem @releases) {
    my $d = tag2date($t);
    my @out = `git show $t:RELEASE-NOTES 2>/dev/null`;
    my $n = options(@out);
#    my $c = contribs(@out);
#    my $loc = loc($t);

    if($n) {
        # prettyfy
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        print "$t;$d;$n\n";
    }
}

my $current = 0 + `grep -E '^  {"... --' src/tool_listhelp.c | wc -l`;

if($current) {
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        localtime(time);
    $date = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
    print "now;$date;$current\n";
}
