#!/usr/bin/perl

# severity high+critical vs low+median reported per year
#
my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";

for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date,
        $report, $cwe, $award, $area, $cissue, $where, $severity)=split('\|');
    my $year=int($date/10000);
    if($severity =~ /^(low|medium)/i) {
        $low{$year}++;
    }
    else {
        $high{$year}++
    }
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

# go to this year
for my $y (1998 .. $year) {
    push @pp, $v{$_};
    if(scalar(@pp) > 5) {
        shift @pp;
    }
    push @ipp, $intro{$_};
    if(scalar(@ipp) > 5) {
        shift @ipp;
    }
    printf "%d-01-01;%d;%d\n", $y, $low{$y}, $high{$y};
    $total += $low{$y} + $high{$y};
}

#print STDERR "$total\n";
