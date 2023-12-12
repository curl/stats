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

sub cpyuse {
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

    open(G, "git show $cmd 2>/dev/null| grep -E '(mem|str|strn)cpy\\('|");
    while(<G>) {
        $count++;
    }
    close(G);

    open(G, "git show $cmd 2>/dev/null| grep -E '(re|m|c)alloc\\('|");
    while(<G>) {
        $alloc++;
    }
    close(G);

    my $blanks, $comments, $code;
    open(G, "git show $cmd 2>/dev/null| cloc --force-lang=C --csv -|");
    while(<G>) {
        if($_ =~ /^1,SUM,(\d*),(\d*),(\d*)/) {
            ($blanks, $comments, $code)=($1, $2, $3);
            last;
        }
    }
    close(G);

    return ($count, $alloc, $code);
}

print <<CACHE
CACHE
    ;

sub show {
    my ($t, $d) = @_;
    my ($cpy, $alloc, $code) = cpyuse($t, "lib");
    printf "$d;%u;%u;%u;%u\n", $code / $cpy, $cpy, $code / $alloc, $alloc;
}

foreach my $t (sort sortthem @releases) {
 #   if(num($t) < 80400) {
 #       next;
 #   }
    my $d = tag2date($t);
    show($t, $d);
}

$t=`git describe`;
chomp $t;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
my $d = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;

show($t, $d);
