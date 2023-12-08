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
my $oc;
my $onc;
for my $d (sort keys %overtime) {
    if($d =~ /(\d\d\d\d)(\d\d)(\d\d)/) {
        $all += $numissues{$d};
        $cmistakes += $numcissues{$d};
        my $nonc = $all - $cmistakes;

        my $showc;
        my $shownc;
        $showc = $cmistakes if($cmistakes != $oc);
        $shownc = $nonc if($nonc != $onc);
        printf "$1-$2-$3;%u;%s;%s;%.2f\n", $all, $showc, $shownc,
            $cmistakes * 100/ $all;
        $oc = $cmistakes;
        $onc = $nonc;
    }
}
