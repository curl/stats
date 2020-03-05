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
            # strip off the time and time zone
            $d = "$1";
            last;
        }
    }
    close(G);
    return $d;
}

#$travisbuilds=`grep -c -e "- os:" .travis.yml`;
#$cirrusbuilds=`grep -c image_family .cirrus.yml`;
#$appveyorbuilds=`grep -c "APPVEYOR_BUILD_WORKER_IMAGE" appveyor.yml`;
#$azurebuilds=`grep -c -e "  - job:" .azure-pipelines.yml`;
#$githubbuilds=`grep runs-on .github/workflows/* | wc -l`;

sub githubcount {
    my ($tag)=@_;
    my @files= `git ls-files -- .github/workflows 2>/dev/null`;
    my $c = 0;
    foreach my $f (@files) {
        chomp $f;
        open(G, "git show $tag:$f 2>/dev/null|");
        while(<G>) {
            if($_ =~ /^    runs-on:/) {
                $c++;
            }
        }
        close(G);
    }
    return $c;
}

sub azurecount {
    my ($tag)=@_;
    open(G, "git show $tag:.azure-pipelines.yml 2>/dev/null|");
    my $c = 0;
    while(<G>) {
        if($_ =~ /^  - job:/) {
            $c++;
        }
    }
    close(G);
    return $c;
}

sub appveyorcount {
    my ($tag)=@_;
    open(G, "git show $tag:appveyor.yml 2>/dev/null|");
    my $c = 0;
    while(<G>) {
        if($_ =~ /^      - APPVEYOR_BUILD_WORKER_IMAGE:/) {
            $c++;
        }
    }
    close(G);
    return $c;
}

sub cirruscount {
    my ($tag)=@_;
    open(G, "git show $tag:.cirrus.yml 2>/dev/null|");
    my $c = 0;
    while(<G>) {
        if($_ =~ /^      (image_family|image):/) {
            $c++;
        }
    }
    close(G);
    return $c;
}

sub traviscount {
    my ($tag)=@_;
    open(G, "git show $tag:.travis.yml 2>/dev/null|");
    my $c = 0;
    while(<G>) {
        if($_ =~ /^        - os:/) {
            $c++;
        }
    }
    close(G);
    return $c;
}


sub cicount {
    my ($tag)=@_;

    return traviscount($tag) + cirruscount($tag) + appveyorcount($tag) +
        azurecount($tag) + githubcount($tag);
}

print <<MOO
curl-7.34.0;2013-10-17;2
curl-7.45.0;2016-07-28;4
MOO
    ;

#push @releases, 'curl-7_68_0-179-g1f114be62';

foreach my $t (sort sortthem @releases) {

    if(num($t) < 75400) {
        # before 7.54.0 we find nothing
        next;
    }

    my $c = cicount($t);
    if($c) {
        # prettyfy
        my $d = tag2date($t);
        $t =~ s/_/./g;
        $t =~ s/-/ /g;
        print "$t;$d;$c\n";
    }
}
