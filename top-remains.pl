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


my $total;
sub singlefile {
    my ($tag, $f) = @_;
    open(G, "git blame --line-porcelain $f $tag|");
    my $author;
    while(<G>) {
        if(/^author (.*)/) {
            $authors{$1}++;    # per this tag
            $total++;
        }
    }
    close(G);
}

sub show {
    my ($tag) = @_;
    my $index;
    my @f=`git ls-tree -r --name-only $tag -- include src lib 2>/dev/null`;

    for my $e (@f) {
        chomp $e;
        if(($e =~ /\.[ch]\z/) || ($e =~ /makefile/i)) {
            singlefile($tag, $e);
        }
    }

    # output the top-20 authors
    for my $a (sort {$authors{$b} <=> $authors{$a} } keys %authors) {
        printf "%d;%s %.2f%%;%u\n", $index,
            $a, $authors{$a}*100/$total, $authors{$a};
        if(++$index == 40) {
            last;
        }
    }
}

my @a = sort sortthem @releases;
my $t = $a[ $#a -1 ];

my $d = tag2date($t);
show("master");

