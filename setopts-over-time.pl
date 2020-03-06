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
    my @file = @_;

    foreach $f (@file) {
        if($f =~ /curl_easy_setopt\(\) options: *(\d+)/) {
            return $1;
        }
    }
    return 0;
}

print <<INIT
curl 7.1.1;2000-08-21;59
curl 7.4.1;2000-10-16;63
curl 7.9;2001-09-23;82
curl 7.10;2002-10-01;100
curl 7.10.7;2003-07-28;107
INIT
    ;

foreach my $t (sort sortthem @releases) {
    if(num($t) <= 70101) {
        next;
    }
    my $d = tag2date($t);
    my @out = `git show $t:RELEASE-NOTES 2>/dev/null`;
    my $n = options(@out);
    if($n) {
        # prettify
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        print "$t;$d;$n\n";
    }
}
