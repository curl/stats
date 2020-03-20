#!/usr/bin/perl

# NOTE:
#
# This accesses the web site git repo to find the 'vuln.pm' file with the
# proper meta-data!

my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";

my $amount = 0;
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date)=split('\|');
    my $y, $m, $d;
    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/) {
        ($y, $m, $d)=(0+$1, 0+$2, 0+$3);
    }
    my $p = sprintf("%04d-%02d-%02d", $y, $m, $d);
    $amount{$cve} = ++$amount;
    $when{$cve} = $p;
    push @all, $cve;
}

my $l;

print <<MOO
none;1998-03-20;0
MOO
    ;

my $end;
for my $cve (@all) {
    my $l = $amount{$cve};
    my $d = $when{$cve};
    printf "%s;%s;%d\n", $cve, $d, $l;
    $end = $l;
}
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
printf "now;%04d-%02d-%02d;%d\n", $year + 1900, $mon + 1, $mday, $end;
