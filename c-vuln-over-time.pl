#!/usr/bin/perl

my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";
require "./stats/tag2date.pm";

my $num = $#vuln + 1;
my $ciss;
my $count;
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $project, $cwe, $award, $area, $cissue,
        $part, $sev, $issue)=split('\|');
    if(!$cissue) {
        print "$cve!\n";
        exit;
    }
    my $d = $start;
    $d =~ s/\./_/g;
    $date = tag2date("curl-$d");
    if(!$date) {
        print STDERR "Tag $d has no date!\n";
        $date = "2000-01-01";
    }

    # there can be several on the same date
    $numissues{$date}++;
    $numcissues{$date}++ if($cissue ne "-");
    $highcissues{$date}++ if(($cissue ne "-") &&
                             (($sev eq "high") || ($sev eq "critical")));
    $highncissues{$date}++ if(($cissue eq "-") &&
                              (($sev eq "high") || ($sev eq "critical")));
    $overtime{$date}++;
}

for my $d (keys %rolling) {
    $seconds{$d} = `date +%s -d "$d"`;
}

my $all;
my $cmistakes;
my $oc;
my $onc;
for my $d (sort keys %overtime) {
    if($d =~ /(\d\d\d\d)-(\d\d)-(\d\d)/) {
        $all += $numissues{$d};
        $cmistakes += $numcissues{$d};
        $hmistakes += $highcissues{$d};
        $hncmistakes += $highncissues{$d};
        my $nonc = $all - $cmistakes;

        my $showc = $cmistakes;
        my $shownc = $nonc;
        my $showhc = $hmistakes;
        my $showhnc = $hncmistakes;
        if($cmistakes == $oc) {
            $showc = "";
        }
        if($nonc == $onc) {
            $shownc = "";
        }
        if($hmistakes == $ohc) {
            $showhc = "";
        }
        if($hncmistakes == $onhc) {
            $showhnc = "";
        }
        printf "$1-$2-$3;%u;%s;%s;%s;%s\n", $all, $showc, $shownc, $showhc, $showhnc;
        $oc = $cmistakes;
        $onc = $nonc;
        $ohc = $hmistakes;
        $onhc = $hncmistakes;
    }
}
