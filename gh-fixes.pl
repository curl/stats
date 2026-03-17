#!/usr/bin/perl

require "./stats/median.pm";

# 1. figure out when all known issues and PRs were created
# 2. find git commits that "fixed" or "closed" issues/PRs - give
#    preference to "fixes". Sometimes more than one commit fix or
#    close an issue
# 3. Figure out time deltas (fixed issues' life times)
# 4. Output the list, in (closing) date order with life time

use Time::Piece;

# get the main github CSV and output a new one
my $c = $ARGV[0];

if(!$c) {
    print "Usage: gh-monthly.pl [gh-CSV]\n";
    exit;
}

sub epoch2date {
    my ($epoch)=@_;
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
        gmtime($epoch);
    return sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
}

## scan the github CSV
open(G, "<$c");
while(<G>) {
    chomp $_;
    my @f = split(";", $_);
    # 2015-08-14T05:53:43Z
    $created{$f[0]} = $f[2];
}
close(G);

my $git = "git log --pretty=fuller --date=unix";

open(G, "$git|");
while(<G>) {
    # date comes before log
    if($_ =~ /^CommitDate: (.*)/) {
        $commit = $1;
    }
    elsif(($_ =~ /^    fixes (#|)(\d+)/i) ||
          ($_ =~ /^    fixes https:\/\/([^0-9]*)\/(\d+)/i) ) {
        my $issue = $2;
        if(!$created{$issue}) {
            #print STDERR "fixed non-existing issue $issue\n";
        }
        else {
            $fixed{$issue}=$commit;
            $handled{$issue} |= 1;
            #print "fixed existing issue $issue\n";
        }
    }
    elsif(($_ =~ /^    clo(s|)ses (#|)(\d+)/i) ||
          ($_ =~ /^    clo(s|)ses https:\/\/github.com\/curl\/curl\/(.*)\/(\d+)/i) ) {
        my $issue = $3;
        if(!$created{$issue}) {
            #print STDERR "closed non-existing issue $issue\n";
        }
        else {
            $closed{$issue}=$commit;
            $handled{$issue} |= 2;
            #print "closed existing issue $issue\n";
        }
    }
}

# iterate over all "handled" issues, set 'done' and 'epoch'
foreach $i (sort {$a <=> $b} keys %handled) {
    my $over = $handled{$i} & 1 ? $fixed{$i} : $closed{$i};
    $done{$i} = $over; # a single end time
    # 2015-08-14T05:53:43Z
    my $t = Time::Piece->strptime($created{$i}, "%Y-%m-%dT%H:%M:%SZ");
    $epoch{$i} = $t->epoch;
    $closedissue{$over} = $i; # close time to issue look-up
}

my $oneyear = (24*3600*365);

my $p;
# iterate over all "handled" issues, sorted by done time
foreach $i (sort {$done{$a} <=> $done{$b}} keys %handled) {
    # issue, done date, life time in number of hours
    my $lifetime = ($done{$i} - $epoch{$i})/3600;

    push @dates, $done{$i};
    push @times, $lifetime;

    my $yearago = $done{$i} - $oneyear;
    # trim off data older than a year
    while(@dates[0] < $yearago) {
        shift @dates;
        shift @times;
    }
    if(scalar(@times) < 1) {
        print "errro\n";
        exit;
    }

    # done date, 12 month median
    my $n = epoch2date($done{$i});
    if($n ne $p) {
        # show each date only once
        printf "%s;%.2f\n", epoch2date($done{$i}), median(@times);
        $p = $n;
    }
}
