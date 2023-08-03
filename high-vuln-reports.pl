#!/usr/bin/perl

my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";
require "./stats/tag2date.pm";

my $num = $#vuln + 1;
my $ciss;
my $count;
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $project, $cwe, $award, $area, $cissue,
        $where, $severity)=split('\|');
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
    $numhighcrit{$date}++ if($severity =~ /^(high|critical)/i);
    $numhigh{$date}++ if($severity eq "high");
    $numcrit{$date}++ if($severity eq "critical");
    $numlow{$date}++ if($severity eq "low");
    $nummed{$date}++ if($severity eq "medium");
    $overtime{$date}++;
}

for my $d (keys %rolling) {
    $seconds{$d} = `date +%s -d "$d"`;
}

my $all;
my $hmistakes;
my $alllow;
my $allmed;
my $allhigh;
my $allcrit;

my $olow;
my $omed;
my $ohi;
my $ocr;

for my $d (sort keys %overtime) {
    if($d =~ /(\d\d\d\d)(\d\d)(\d\d)/) {
        $all += $numissues{$d};
        $hmistakes += $numhighcrit{$d};

        $alllow += $numlow{$d};
        $allmed += $nummed{$d};
        $allhigh += $numhigh{$d};
        $allcrit += $numcrit{$d};

        my $slow = $alllow;
        my $smed = $allmed;
        my $shi = $allhigh;
        my $scr = $allcrit;

        $slow = "" if($alllow == $olow);
        $smed = "" if($allmed == $omed);
        $shi = "" if($allhigh == $ohi);
        $scr = "" if($allcrit == $ocr);

        printf "$1-$2-$3;%u;%s;%s;%s;%s;%.2f\n", $all, $slow, $smed,
            $shi, $scr, $hmistakes * 100/ $all;

        $olow = $alllow;
        $omed = $allmed;
        $ohi = $allhigh;
        $ocr = $allcrit;
    }
}
