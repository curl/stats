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

sub githubcount {
    my ($tag)=@_;
    my @files= `git ls-tree -r --name-only $tag .github/workflows 2>/dev/null`;
    my $linux = 0;
    my $mac = 0;
    my $windows = 0;
    foreach my $f (@files) {
        my $j = 0;
        my $m = -1;
        my $os = "";
        chomp $f;
        open(G, "git show $tag:$f 2>/dev/null|");
        # start counting file jobs
        while(<G>) {
            if($_ =~ /runs-on: (.*)/) {
                # commit previously counted jobs to previous os
                my $n = $1;
                if($os =~ /ubuntu/) {
                    $linux += $j;
                }
                elsif($os =~ /macos/i) {
                    $mac += $j;
                }
                elsif($os =~ /windows/i) {
                    $windows += $j;
                }
                $os = $n;
                # non-matrix job
                $j = 1;
            }
            elsif($_ =~ /matrix:/) {
                # switch to matrix mode
                $m = 0;
                $j = 0;
            }
            elsif($m >= 0) {
                if($_ =~ /- name:/) {
                    # matrix job
                    $j += ($m?$m:1);
                }
                elsif($_ =~ /- CC:/) {
                    # matrix multiplier
                    $m++;
                }
                elsif($_ =~ /steps:/) {
                    # disable matrix mode
                    $m = -1;
                }
            }
        }
        close(G);
        # commit final counted jobs to last os
        if($os =~ /ubuntu/) {
            $linux += $j;
        }
        elsif($os =~ /macos/i) {
            $mac += $j;
        }
        elsif($os =~ /windows/i) {
            $windows += $j;
        }
        # reset internal job counter
        $j = 0;
    }
    return ($linux, $mac, $windows);
}

sub azurecount {
    my ($tag)=@_;
    open(G, "git show $tag:.azure-pipelines.yml 2>/dev/null|");
    my $linux = 0;
    my $mac = 0;
    my $windows = 0;
    my $j = 0;
    my $m = -1;
    my $os = "";
    while(<G>) {
        if($_ =~ /vmImage: (.*)/) {
            # commit previously counted jobs to previous os
            my $n = $1;
            if($os =~ /ubuntu/) {
                $linux += $j;
            }
            elsif($os =~ /macos/i) {
                $mac += $j;
            }
            elsif($os =~ /windows/i) {
                $windows += $j;
            }
            $os = $n;
            # non-matrix job
            $j = 1;
        }
        elsif($_ =~ /matrix:/) {
            # switch to matrix mode
            $m = 0;
            $j = 0;
        }
        elsif($m >= 0) {
            if($_ =~ /name:/) {
                # single matrix list entry job
                $j++;
            }
            # azure matrix is a simple list,
            # therefore no multiplier needed
            elsif($_ =~ /steps:/) {
                # disable matrix mode
                $m = -1;
            }
        }
    }
    close(G);
    # commit final counted jobs to last os
    if($os =~ /ubuntu/) {
        $linux += $j;
    }
    elsif($os =~ /macos/i) {
        $mac += $j;
    }
    elsif($os =~ /windows/i) {
        $windows += $j;
    }
    return ($linux, $mac, $windows);
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
    my $freebsd = 0;
    my $windows = 0;
    while(<G>) {
        if($_ =~ /(image_family|image): freebsd/) {
            $freebsd++;
        }
        elsif($_ =~ /- name: Windows/) {
            $windows++;
        }
    }
    close(G);
    return ($freebsd, $windows);
}

sub traviscount {
    my ($tag, $now)=@_;
    open(G, "git show $tag:.travis.yml 2>/dev/null|");
    my $c = 0;
    my $linux=0;
    my $mac=0;
    if((num($tag) > 77700) || ($tag eq $now)) {
        # travis is dead
        return (0, 0);
    }
    elsif(num($tag) > 77000) {
        # white space edits and linux-only
        while(<G>) {
            if($_ =~ /^  - env:/) {
                $linux++;
            }
        }
    }
    else {
        while(<G>) {
            if($_ =~ /os: linux/) {
                $linux++;
            }
            elsif($_ =~ /os: osx/) {
                $mac++;
            }
        }
    }
    close(G);
    return ($linux, $mac);
}

sub circlecicount {
    my ($tag)=@_;
    open(G, "git show $tag:.circleci/config.yml 2>/dev/null|");
    my $linux = 0;
    my $wf = 0;
    while(<G>) {
        if($_ =~ /^workflows/) {
            $wf = 1;
        }
        elsif($wf) {
            if($_ =~ / *jobs:/) {
                $linux++;
            }
        }
    }
    close(G);
    return $linux;
}

sub zuulcount {
    my ($tag)=@_;
    open(G, "git show $tag:zuul.d/jobs.yaml 2>/dev/null|");
    my $linux = 0;
    my $wf = 0;
    while(<G>) {
        if($_ =~ /^- job:/) {
            $linux++;
        }
    }
    close(G);
    return $linux;
}


my @this = sort sortthem @releases;

my $now = `git describe`;
chomp $now;

# top off with the current state
push @this, $now;

foreach my $t (@this) {

    if(($t ne $now) && num($t) < 75400) {
        # before 7.54.0 we find nothing
        next;
    }

    my ($linux, $mac) = traviscount($t, $now);
    my ($freebsd, $windows) = cirruscount($t);
    $windows += appveyorcount($t);

    my ($l2, $m2, $w2) = azurecount($t);
    $linux += $l2;
    $mac += $m2;
    $windows += $w2;

    my ($l3, $m3, $w3) = githubcount($t);
    $linux += $l3;
    $mac += $m3;
    $windows += $w3;

    $linux += circlecicount($t);
    $linux += zuulcount($t);

    my $c = $linux + $mac + $windows + $freebsd;
    if($c) {
        # prettify
        my $d;
        my $d = tag2date($t);
        if($t ne $now) {
            $t =~ s/_/./g;
            $t =~ s/-/ /g;
        }
        else {
            $t = "now";
        }
        # skip $t
        printf "$d;$c;%d;%d;%d;%d\n", $linux, $mac, $windows, $freebsd;
    }
}
