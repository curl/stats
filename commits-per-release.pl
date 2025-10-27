#!/usr/bin/perl

require "./stats/tag2date.pm";
require "./stats/average.pm";
require "./stats/median.pm";

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

sub count {
    my ($tag) = @_;
    my $count = `git rev-list --count $tag`;
    return ($count);
}

print <<CACHE
CACHE
    ;

sub date2secs {
    my ($d) = @_;
    #print STDERR "date: $d\n";
    return 0 + `date -d $d +%s`;
}

sub deltadays {
    my ($older, $newer) = @_;
    return (date2secs($newer)/86400) - (date2secs($older)/86400);
}


sub show {
    my ($t, $d, $prev) = @_;
    my ($commits) = count($t);
    my $delta = $commits - $prev;
    push @alldelta, $delta;
    my $me = median(@alldelta);

    push @dates, $d;
    push @vals, $delta;
    while(deltadays(@dates[0], $d) > 365) {
        shift @dates;
        shift @vals;
    }
    my $av = average(@vals);

    printf "$d;%u;%u;%u;%.1f\n", $commits, $delta, $me, $av;
    return $commits;
}

my $prev = 0;
foreach my $t (sort sortthem @releases) {
#    if(num($t) <= 81101) {
#        next;
# }
    my $d = tag2date($t);
    $prev = show($t, $d, $prev);
}

$t=`git describe --match "curl*"`;
chomp $t;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
my $d = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
show($t, $d, $prev);
