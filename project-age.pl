#!/usr/bin/perl

my $httpget = 847710000; # Mon 11 Nov 1996 12:00:00 PM CET
my $curl4 =   890391600; # Fri Mar 20 12:00:00 PM CET 1998
my $curl71 =  965642400; #Mon Aug  7 12:00:00 PM CEST 2000

my $eday = 3;  # this many day bumps
my $every = $eday*24*3600;

my $c4delta = int(($curl4 - $httpget) / (24*3600));
my $c7delta = int(($curl71 - $httpget) /  (24*3600));

#print "$c4delta $c7delta\n";

my $days = 0;
my $e;
my $now = time();
for($e = $httpget;
    $e < $now;
    $e += $every) {
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) =
        localtime($e);
    printf "%04d-%02d-%02d;%d;%d;%d\n", $year + 1900, $mon + 1, $mday,
        $days, $days - $c4delta, $days - $c7delta;
    $days += $eday;
}
