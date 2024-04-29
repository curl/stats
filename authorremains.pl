#!/usr/bin/perl

require "./stats/tag2date.pm";

my %authors;
my %authorever;

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


sub singlefile {
    my ($tag, $f) = @_;
    open(G, "git blame --line-porcelain $f $tag|");
    my $author;
    while(<G>) {
        if(/^author (.*)/) {
            $authors{$1}++;    # per this tag
            $authorever{$1}++; # through all time
        }
    }
    close(G);
}

sub show {
    my ($tag, $date) = @_;
    my @f=`git ls-tree -r --name-only $tag -- src lib include 2>/dev/null`;

    for my $e (@f) {
        chomp $e;
        if(($e =~ /\.[ch]\z/) || ($e =~ /makefile/i)) {
            singlefile($tag, $e);
        }
    }

    # number of people left, number of people with former contributions
    my $rem = scalar(%authorever) - scalar(%authors);
    $rem ="" if(!$rem);
    printf "$date;%u;%s\n", scalar(%authors), $rem;
        ;
    undef %authors;
}

foreach my $t (sort sortthem @releases) {
    if(num($t) < 0) {
        next;
    }
    my $d = tag2date($t);
    show($t, $d);
}
