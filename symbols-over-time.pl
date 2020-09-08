#!/usr/bin/perl

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

sub tag2date {
    my ($t)=@_;
    open(G, "git show $t --pretty=\"Date: %ci\" -s 2>/dev/null|");
    my $d;
    while(<G>) {
        if($_ =~ /^Date: (\d+-\d+-\d+) (\d+:\d+:\d+)/) {
            # strip off the time zone and time
            $d = "$1";
            last;
        }
    }
    close(G);
    return $d;
}

sub options {
    my ($tag, $file) = @_;
    my @t = `git show $tag:$file 2>/dev/null`;
    my $c =0;
    foreach $l (@t) {
        if($l =~ /^[^ ]/) {
            $c++;
        }
    }
    return $c;
}

foreach my $t (sort sortthem @releases) {
    my $d = tag2date($t);
    my $n = options($t, "docs/libcurl/symbols-in-versions");

    if($n || $k) {
        # prettyfy
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        print "$d;$n\n";
    }
}

$t=`git describe`;
chomp $t;

my $n = options($t, "docs/libcurl/symbols-in-versions");
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
$date = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
print "$date;$n\n";
