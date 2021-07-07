#!/usr/bin/perl

# number of vulns reported per year
#
my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";


for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date)=split('\|');
    my $year=int($date/10000);
    $v{$year}++;
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
for(1998 .. $year) {
    $total += $v{$_};

    push @pp, $v{$_};
    if(scalar(@pp) > 5) {
        shift @pp;
    }
    # writes a full date just to be parsable
    printf "%d-01-01;%d;%d;%.2f\n", $_, $v{$_}, $total, average(@pp);
}
