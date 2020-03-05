#!/usr/bin/perl

# NOTE:
#
# This accesses the web site git repo to find the 'vuln.pm' file with the
# proper meta-data!

require "../curl-www/docs/vuln.pm";

my $amount = 0;
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date)=split('\|');
    my $y, $m, $d;
    if($date =~ /^(\d\d\d\d)(\d\d)(\d\d)/) {
        ($y, $m, $d)=(0+$1, 0+$2, 0+$3);
    }
    my $p = sprintf("%04d-%02d-%02d", $y, $m, $d);
    $ym{"$p"} = ++$amount;
}

my $l;

print <<MOO
1998-03-20;0
MOO
    ;

for my $m (sort keys %ym) {
    my $l = $ym{"$m"};
    printf "%s;%d\n", $m, $l;
}
