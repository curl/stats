#!/usr/bin/perl

sub median {
    my @a = @_;
    my @vals = sort {$a <=> $b} @a;
    my $len = @vals;
    if($len%2) { #odd?
        return $vals[int($len/2)];
    }
    else {
        #even
        return ($vals[int($len/2)-1] + $vals[int($len/2)])/2;
    }
}

sub percentile {
    my ($per, @a) = @_;
    my @vals = sort {$a <=> $b} @a;
    my $len = @vals;
    return $vals[int($len * $per/100)];
}

sub average {
    my @p = @_;
    my $sum;
    for my $y (@p) {
        $sum += $y;
    }
    return $sum / scalar(@p);
}

sub newerthan {
    my ($threshold, @p) = @_;
    my $sum;
    for my $y (@p) {
        $sum++ if($y > $threshold);
    }
    return $sum;
}

sub days {
    my ($ag) = @_;
    return $ag/(24*3600);
}

sub showage {
    my ($ag) = @_;
    my $y = $ag/(365*24*3600);
    my $d = $ag/(24*3600);
    if($y < 1) {
        if($d < 2) {
            my $h = $ag/3600;
            return sprintf("%.1f hours", $h);
        }
        return sprintf("%.1f days", $d);
    }
    return sprintf("%.2f years (%d days)", $y, $d);
}

sub runfile {
    my ($verbose, $file) = @_;

    if(! -f $file) {
        print STDERR "no such file: $file\n";
        return;
    }

    my $lines = 0;
    my @stamp;
    open(BLAM, "git blame -t $file 2>/dev/null|");
    while(<BLAM>) {
        if(/^.* +(\d+) [+-][01][0-9][0-9]0 /) {
            push @stamp, $1;
            $lines++;
        }
    }
    close(BLAM);

    my $commits = `git log --follow --oneline -- $file | wc -l`;
    my $lcommits = `git log --follow --oneline --since='365 days' -- $file | wc -l`;
    my $now = time;
    my $lyear = newerthan($now-(365*24*3600), @stamp);

    my $o = $now - (sort {$a <=> $b} @stamp)[0];
    my $oldstamp = (sort {$a <=> $b} @stamp)[0];
    my $all=0;
    my $oldest=0;
    for my $a (@stamp) {
        if($a eq $oldstamp) {
            $oldest++;
        }
        $all++;
    }
    $untouched = $oldest*100/$all;
    if($verbose) {
        print "===== $file\n";

        printf "Untouched original lines: %.2f%% (%d out of %d)\n",
            $untouched, $oldest, $all;
        printf "Oldest: %s\n", showage($o);
    }
    my @ptile;
    for ($p=10; $p <= 90; $p+= 10) {
        my $when = percentile($p, @stamp);
        my $sage = $now - $when;
        $ptile[$p]=$sage;
        printf "percentile-$p: %s\n", showage($sage) if($verbose);
    }

    my $y = $now - (sort {$b <=> $a} @stamp)[0];
    printf "Youngest: %s\n", showage($y) if($verbose);

    my $avr = average(@stamp);
    my $vage = $now - $avr;
    if($verbose) {
        printf "Average: %s\n", showage($vage);
        printf "Lines: %d\n", $lines;
        printf "Commits: %d\n", $commits;
        printf "Lines / commit: %.1f\n", $lines/ $commits;
        printf "Lines changed within last year: %d (%.2f%%)\n", $lyear, $lyear*100/$lines;
        printf "Commits within last year: %d (%.2f%%)\n", $lcommits, $lcommits*100/$commits;
    }
    else {
        printf "$file;%d;", days($o);
        for ($p=10; $p <= 90; $p+= 10) {
            printf "%d;", days($ptile[$p]);
        }
        printf "%d;%d;%d;%d;%.2f;%d;%.2f;%d;%.2f;%.2f\n",
            days($y), days($vage),
            $lines, $commits, $lines/ $commits,
            $lyear, $lyear*100/$lines,
            $lcommits, $lcommits*100/$commits,
            $untouched;
    }
}

my $verbose = 0;
if($ARGV[0] eq "-v") {
    $verbose = 1;
    shift @ARGV;
}

print "filename;oldest;p10;p20;p30;p40;p50;p60;p70;p80;p90;".
    "newest;average;lines;commits;lines/commits;".
    "lines this year;%lines this year;".
    "commits this year;%commits this year;%untouched\n" if(!$verbose);

for my $file (@ARGV) {
    runfile($verbose, $file);
}
