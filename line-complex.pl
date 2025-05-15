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

sub p99 {
    my @a = @_;
    my @vals = sort {$b <=> $a} @a;
    my $i = scalar(@vals) * 0.01;
    return $vals[$i];
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

sub complexity {
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

    #  Modified McCabe Cyclomatic Complexity
    #  |   Traditional McCabe Cyclomatic Complexity
    #  |       |    # Statements in function
    #  |       |        |   First line of function
    #  |       |        |       |   # lines in function
    #  |       |        |       |       |

    my $score;
    my $funcs;
    my $totlines;

    open(G, "git show $cmd 2>/dev/null| pmccabe 2>/dev/null|");
    while(<G>) {
        if($_ =~ /^(\d+)\t(\d+)\t(\d+)\t(\d+)\t(\d+)/) {
            my ($modmccabe, $mccabe, $statements, $first, $lines)=($1, $2, $3, $4, $5);
            if($modmccabe > 1000) {
                # something is wrong
                #print STDERR $_;
                return 0;
            }
            $score += $modmccabe * $lines;
            $funcs++;
            $totlines += $lines;
        }
    }
    close(G);
    #print STDERR "$score for $totlines\n";
    return $score / $totlines;
}

print <<CACHE
CACHE
    ;

sub show {
    my ($t, $d) = @_;
    my ($score) = complexity($t, "src lib");
    if($score) {
        printf "$d;%.3f\n", $score;
    }

}

foreach my $t (sort sortthem @releases) {
   # if(num($t) <= 81300) {
   #     next;
   # }
    my $d = tag2date($t);
    show($t, $d);
}

$t=`git describe --match "curl*"`;
chomp $t;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
my $d = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;

show($t, $d);
