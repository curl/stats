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
    my @files= `git ls-files -- .github/workflows 2>/dev/null`;
    my $c = 0;
    my $linux;
    foreach my $f (@files) {
        chomp $f;
        my $matrix = 0;
        if($f =~ "/macos.yml") {
            # this introduced the use of the matrix style
            $matrix = 1;
        }
        open(G, "git show $tag:$f 2>/dev/null|");
        if(!$matrix) {
            while(<G>) {
                if($_ =~ /^    runs-on:/) {
                    $linux++;
                }
            }
        }
        else {
            my $mult = 0;
            while(<G>) {
                if($_ =~ /matrix:/) {
                    $mult = 0;
                }
                elsif($_ =~ /- name:/) {
                    $c += ($mult?$mult:1);
                }
                elsif($_ =~ /- CC:/) {
                    $mult++;
                }
            }
        }
        close(G);
    }
    return ($c, $linux);
}

sub azurecount {
    my ($tag)=@_;
    open(G, "git show $tag:.azure-pipelines.yml 2>/dev/null|");
    my $c = 0;
    my $linux;
    my $mac;
    my $windows;
    while(<G>) {
        if($_ =~ /vmImage: '(.*)'/) {
            if($1 =~ /ubuntu/) {
                $linux++;
            }
            elsif($1 =~ /macos/i) {
                $mac++;
            }
            elsif($1 =~ /windows/i) {
                $windows++;
            }
        }
    }
    close(G);
    return ($mac, $linux, $windows);
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
    my $mac=0;
    my $linux=0;
    while(<G>) {
        if($_ =~ /os: osx/) {
            $mac++;
        }
        elsif($_ =~ /os: linux/) {
            $linux++;
        }
    }
    close(G);
    return ($mac, $linux);
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

    my ($mac, $linux) = traviscount($t);
    my $freebsd = cirruscount($t);
    my $windows = appveyorcount($t);
    my ($m2, $l2, $w2) = azurecount($t);
    $mac += $m2;
    $linux += $l2;
    $windows += $w2;

    ($m2, $l2) = githubcount($t);
    $mac += $m2;
    $linux += $l2;

    my $c = $mac + $linux + $windows + $freebsd;
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
