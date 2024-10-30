#!/usr/bin/perl

require "./stats/tag2date.pm";

my %authors;

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

# P is the percentile
# start is the epoch date of the release
# @a is the array of epoch commit dates
#
# Returns the value in number of months (float)
sub px {
    my ($p, $start, @a) = (@_);
    my @vals = sort {$a <=> $b} @a;
    my $len = @vals;
    my $i = scalar(@vals) * $p/100;
    return ($start - $vals[$i]) / (365.25 * 24 * 3600);
}

sub singlefile {
    my ($tag, $f) = @_;
    open(G, "git blame -t --line-porcelain $f $tag|");
    my $author;
    my @stamp;
    while(<G>) {
        if(/^committer-time (.*)/) {
            # store every timestamp
            push @stamp, $1;
        }
    }
    close(G);
    return @stamp;
}

sub show {
    my ($tag, $date) = @_;
    my @stamp;
    my $now = `date +%s -d "$date"`;
    my @f=`git ls-tree -r --name-only $tag -- src lib include 2>/dev/null`;

    for my $e (@f) {
        chomp $e;
        if(($e =~ /\.[ch]\z/) || ($e =~ /makefile/i)) {
            push @stamp, singlefile($tag, $e);
        }
    }

    printf "$date;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f;%.3f\n",
        px(10, $now, @stamp),
        px(20, $now, @stamp),
        px(30, $now, @stamp),
        px(40, $now, @stamp),
        px(50, $now, @stamp),
        px(60, $now, @stamp),
        px(70, $now, @stamp),
        px(80, $now, @stamp),
        px(90, $now, @stamp),
        px(95, $now, @stamp);
}

print <<CACHE
CACHE
    ;

foreach my $t (sort sortthem @releases) {
#    if(num($t) <= 81001) {
#        next;
#    }
    my $d = tag2date($t);
    show($t, $d);
}
