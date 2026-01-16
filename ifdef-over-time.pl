#!/usr/bin/perl

require "./stats/tag2date.pm";

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

sub ifuse {
    my ($tag, $path) = @_;

    # Get source files to count
    my @files;
    open(G, "git ls-tree -r --name-only $tag -- $path 2>/dev/null|");
    while(<G>) {
        chomp;
        if($_ =~ /[ch]\z/) {
            push @files, $_;
        }
    }
    close(G);

    my $cmd;
    for(@files) {
        $cmd .= "$tag:$_ ";
    }

    my $count;
    my $alloc;

    open(G, "git show $cmd 2>/dev/null| grep -a '^ *#if'|");
    while(<G>) {
        $count++;
    }
    close(G);

    return ($count, $code);
}

print <<CACHE
CACHE
    ;

sub show {
    my ($t, $d) = @_;
    my ($ifdefs) = ifuse($t, "lib src");
    printf "$d;%u\n", $ifdefs;
}

foreach my $t (sort sortthem @releases) {
#    if(num($t) <= 81700) {
#        next;
#    }
    my $d = tag2date($t);
    show($t, $d);
}

$t=`git describe --match "curl*"`;
chomp $t;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
my $d = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;

show($t, $d);
