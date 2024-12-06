#!/usr/bin/perl

require "./stats/tag2date.pm";

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

sub p90 {
    my @a = @_;
    my @vals = sort {$b <=> $a} @a;
    my $i = scalar(@vals) * 0.1;
    return $vals[$i];
}

sub worst {
    my @a = @_;
    my @vals = sort {$b <=> $a} @a;
    return $vals[0];
}

sub num {
    my ($t)=@_;
    if($t =~ /^curl-(\d)_(\d+)_(\d+)/) {
        return 10000*$1 + 100*$2 + $3;
    }
    elsif($t =~ /^curl-(\d)_(\d+)/) {
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
        push @releases, $t;
    }
}

sub linesperfile {
    my ($tag, $path) = @_;

    # Get source files to count
    my @files;
    open(G, "git ls-tree -r --name-only $tag -- $path 2>/dev/null|");
    while(<G>) {
        chomp;
        if($_ =~ /\.c\z/) {
            push @files, $_;
        }
    }
    close(G);

    my $lines;
    my @linesperfile;
    my $index = 0;
    for my $f (@files) {
        open(G, "git show $tag:$f 2>/dev/null|");
        while(<G>) {
            $lines++;
            $linesperfile[$index]++;
        }
        close(G);
        $index++;
    }

    return worst(@linesperfile), p90(@linesperfile), median(@linesperfile);
}

print <<CACHE
CACHE
    ;

sub show {
    my ($t, $d) = @_;
    my ($worst, $p90, $median) = linesperfile($t, "src lib");
    printf "$d;%u;%u;%u\n", $worst, $p90, $median;
}

foreach my $t (sort sortthem @releases) {
#    if(num($t) <= 80800) {
#        next;
#    }
    my $d = tag2date($t);
    show($t, $d);
}

$t=`git describe`;
chomp $t;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
my $d = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;

show($t, $d);
