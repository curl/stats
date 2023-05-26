#!/usr/bin/perl

my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";
require "./stats/tag2date.pm";

my $num = $#vuln + 1;
my $ciss;
my $count;
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $project, $cwe, $award, $area, $cissue)=split('\|');
    if(!$cissue) {
        print "$cve!\n";
        exit;
    }
    my $d = $start;
    if($d eq "7.1") {
        $d = "7.1.1";
    }
    $d =~ s/\./_/g;
    #$date = tag2date("curl-$d");
    if(!$date) {
        $date = "2000-01-01";
    }

    # there can be several on the same date
    $numissues{$date}++;
    $numcissues{$date}++ if($cissue ne "-");
    $overtime{$date}++;
}

for my $d (keys %rolling) {
    $seconds{$d} = `date +%s -d "$d"`;
}

print "1998-03-20;0;0;0\n";

my $all;
my $cmistakes;
for my $d (sort keys %overtime) {
    if($d =~ /(\d\d\d\d)(\d\d)(\d\d)/) {
        $all += $numissues{$d};
        $cmistakes += $numcissues{$d};
        printf "$1-$2-$3;%u;%u;%u;%.2f\n", $all, $cmistakes, $all - $cmistakes,
            $cmistakes * 100/ $all;
    }
}
