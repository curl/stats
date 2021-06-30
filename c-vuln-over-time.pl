#!/usr/bin/perl

my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";

my $num = $#vuln + 1;
my $ciss;
my $count;
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $project, $cwe, $award, $area, $cissue)=split('\|');
    if(!$cissue) {
        print "$cve!\n";
        exit;
    }
    $ciss++ if($cissue ne "-");
    $count++;
    $overtime{$date} = sprintf("%.1f", $ciss * 100 / $count);
    $issues{$date}=$count;
    $rolling{$date}= ($cissue ne "-") ? 1 : 0;
}

for my $d (keys %rolling) {
    $seconds{$d} = `date +%s -d "$d"`;
}

sub lastyear {
    my ($from) = @_;
    my $now = $seconds{$from};
    my $sumit;
    my $count;
    for my $d (keys %seconds) {
        if(($seconds{$d} > ($now - 365*24*3600)) &&
           ($seconds{$d} <= $now)) {
            # within the last year
            $sumit += $rolling{$d};
            $count++;
        }
    }
    # percentage
    return $sumit * 100 / $count;
}

for my $d (sort keys %overtime) {
    if($d =~ /(\d\d\d\d)(\d\d)(\d\d)/) {
        printf "$1-$2-$3;%.1f;%.1f;%d\n", $overtime{$d}, lastyear($d),
            $issues{$d};
    }
}
