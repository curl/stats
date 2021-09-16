#!/usr/bin/perl

# number of vulns reported per year
#
my $webroot = $ARGV[0];
my $cveintro = $ARGV[1];
require "$webroot/docs/vuln.pm";

if(!$cveintro) {
    die "missing argument(s)";
}

for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date)=split('\|');
    my $year=int($date/10000);
    $v{$year}++;
}

open(I, "<$cveintro");
while(<I>) {
    if($_ =~ /^(\d+)-(\d+)-(\d+);(\d*)/) {
        $intro{$1}++;
    }
}
close(I);

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
    push @ipp, $intro{$_};
    if(scalar(@ipp) > 5) {
        shift @ipp;
    }
    # writes a full date just to be parsable
    printf "%d-01-01;%d;%d;%d;%.2f;%.2f\n", $_, $v{$_}, $intro{$_}, $total,
        average(@pp), average(@ipp);
}
