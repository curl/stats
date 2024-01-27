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

sub tests {
    my ($tag) = @_;
    my $tests = 0;
    # only count files matching "test[num]"
    open(G, "git ls-tree -r --name-only $tag -- tests/data 2>/dev/null|");
    while(<G>) {
        if($_ =~ /test(\d)/) {
            $tests++;
        }
    }
    close(G);

    my $pydir = "tests/http";
    if(num($tag) < 80000) {
        # before 8.0.0 this named was used
        $pydir = "tests/tests-httpd";
    }

    # find all test py files in 'tests/http'
    open(G, "git ls-tree -r --name-only $tag -- $pydir 2>/dev/null|");
    while(<G>) {
        chomp;
        # count each invidual tests inside these pythong scripts
        if($_ =~ /\/test_(\d).*\.py/) {
            open(GIT, "git show $tag:$_|");
            while(<GIT>) {
                if(/def test_/) {
                    $tests++;
                }
            }
            close(GIT);
        }
    }
    close(G);
    return $tests;
}


foreach my $t (sort sortthem @releases) {
    my $d = tag2date($t);
    my $l = tests($t);
    if($l) {
        # prettyfy
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        print "$t;$d;$l\n";
    }
}

# repeat the last line with current date
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
    localtime(time);
my $date = sprintf "%04d-%02d-%02d", $year + 1900, $mon + 1, $mday;
my $tag = `git describe`;
chomp $tag;
printf "now;$date;%d\n", tests($tag);
