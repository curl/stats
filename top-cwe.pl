#!/usr/bin/perl

my $webroot = $ARGV[0] || "../curl-www";

require "$webroot/docs/vuln.pm";

my %all;
my $total;
for(@vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $report, $cwe, $usd)=split('\|');
    $all{$cwe}++;
    $total++;
}

# output the top CWEs
for my $a (sort {$all{$b} <=> $all{$a} } keys %all) {
    if($all{$a} < 2) {
        last;
    }
    printf "%d;%s %.2f%%;%u\n", $index++, substr($a, 0, 70), $all{$a}*100/$total, $all{$a};
}
