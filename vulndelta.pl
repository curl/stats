#!/usr/bin/perl

# NOTE:
#
# This accesses the web site git repo to find the 'vuln.pm' file with the
# proper meta-data!

my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";

# This is not a standard/default perl module!
use DateTime;

sub parse_date {
  die unless $_[0] =~ m/^(\d\d\d\d)(\d\d)(\d\d)$/;
  return DateTime->new(year => $1, month => $2, day => $3,
    hour => 0, minute => 0, second => 0, time_zone  => 'UTC');
}

my $amount = 0;
my $pdate="19980320"; # birth day
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date)=split('\|');

    my $dt1 = parse_date($pdate);
    my $dt2 = parse_date($date);
    $pdate = $date;

    my $delta = $dt2->delta_days($dt1)->delta_days();

    $date =~ s/(\d\d\d\d)(\d\d)(\d\d)/$1-$2-$3/;
    $cves{$date} .= "$cve ";
    if($delta) {
        $delta{$date} = $delta;
        push @dates, $date;
    }
}

for my $d (@dates) {
    printf "%s;%d;%s\n", $d, $delta{$d}, $cves{$d};
}

my $dt1 = parse_date($pdate);
my $dt2 = DateTime->today();
my $delta = $dt2->delta_days($dt1)->delta_days();

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "%04d-%02d-%02d;%d;now\n", $year + 1900, $mon + 1, $mday, $delta;
