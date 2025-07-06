#!/usr/bin/perl

require "./stats/tag2date.pm";

my $webroot = $ARGV[0] || "../curl-www";
require "$webroot/docs/vuln.pm";

my %begin;
my %end;
for(reverse @vuln) {
    my ($id, $start, $stop, $desc, $cve, $date, $report, $cwe,
        $award, $area, $cissue, $where, $level)=split('\|');
    $begin{$start} .= "$cve,";
    $end{$stop} .= "$cve,";
    $cissue{$cve} = $cissue ne "-";
}

sub num {
    my ($t)=@_;
    if($t =~ /^(\d)\.(\d+)\.(\d+)/) {
        return 10000*$1 + 100*$2 + $3;
    }
    elsif($t =~ /(\d)\.(\d+)/) {
        return 10000*$1 + 100*$2;
    }
}

sub sortthem {
    return num($a) <=> num($b);
}

@alltags= `git tag -l`;

foreach my $t (@alltags) {
    chomp $t;
    if($t =~ /^curl-([0-9_]*[0-9])\z/) {
        push @tags, $t;
    }
}

my @vers = (
    '7.4',
    '6.4',
    '6.3.1',
    '6.3',
    '6.2',
    '6.1',
    '6.0',
    '5.11',
    '5.10',
    '5.9.1',
    '5.9',
    '5.8',
    '5.7.1',
    '5.7',
    '5.5.1',
    '5.5',
    '5.4',
    '5.3',
    '5.2.1',
    '5.2',
    '5.0',
    '4.10',
    '4.9',
    '4.8.4',
    '4.8.3',
    '4.8.2',
    '4.8.1',
    '4.8',
    '4.7',
    '4.6',
    '4.5.1',
    '4.5',
    '4.4',
    '4.3',
    '4.2',
    '4.1',
    '4.0',
    '3.12',
    '3.11',
    '3.10',
    '3.9',
    '3.7',
    '3.6',
    '3.5',
    '3.2',
    '3.1',
    '3.0',
    '2.9',
    '2.8',
    '2.7',
    '2.6',
    '2.5',
    '2.4',
    '2.3',
    '2.2',
    '2.1',
    '2.0',
    '1.5',
    '1.4',
    '1.3',
    '1.2',
    '1.1',
    '1.0',
    '0.3',
    '0.2',
    '0.1');

foreach my $t (@tags) {
    $t =~ s/curl-//;
    $t =~ s/_/./g;
    push @releases, $t;
}

push @releases, @vers;

sub cdetails {
    my ($t) = @_;
    my @id = split(/,/, $t);
    my $cmiss = 0;
    for my $id (@id) {
        $cmiss += $cissue{$id};
    }
    return $cmiss;
}

my $count=0;
foreach my $t (sort sortthem @releases) {
    if($begin{$t}) {
        #printf "first $t: %s\n", $begin{$t};
        $count += scalar(split(/,/, $begin{$t}));
        $forthis .= $begin{$t};
    }
    my $tag = "curl-".$t;
    $tag =~ s/\./_/g;
    my $date = tag2date($tag);
    if(!$date) {
        next;
    }

    my $cmiss = cdetails($forthis);
    my $cshare = 0;
    if($count) {
        $cshare = 100 * $cmiss / $count;
    }
    printf "$date;$t;$count;$cmiss;%.2f\n", $cshare;

    if($end{$t}) {
        my @fixedafter = split(/,/, $end{$t});
        #printf "last $t: %s\n", $end{$t};
        $count -= scalar(@fixedafter);
        # remove each fixed CVE
        for(@fixedafter) {
            $forthis =~ s/$_,//;
        }
    }

}

