#!/usr/bin/perl

# severity high+critical vs low+median reported per year
#
my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";

for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date,
        $report, $cwe, $award, $area, $cissue, $where, $severity)=split('\|');
    my $year=int($date/10000);
    $count{$date, $severity}++;
    push @all, $date; # all reported dates
}

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum / scalar(@p);
}


my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
$year += 1900;

my $l;
my $m;
my $h;
my $c;

# iterate over all dates
for my $y (reverse @all) {
    $l += $count{$y, "low"};
    $m += $count{$y, "medium"};
    $h += $count{$y, "high"};
    $c += $count{$y, "critical"};
    $total = $l +$m + $h + $c;
    my $year = int($y/10000);
    my $mon = int(($y - ($year * 10000))/100);
    my $day = $y - $year * 10000 - $mon * 100;
    printf "%4d-%02d-%02d;%.2f;%.2f;%.2f;%.2f\n", $year, $mon, $day,
        $l*100/$total,
        ($m + $l)*100/$total,
        ($h + $m + $l)*100/$total,
        ($c + $h + $m+$l)*100/$total if($total);
}

#print STDERR "$total\n";
