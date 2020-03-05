#!/usr/bin/perl

#open(L, "git log --reverse --date=short --stat -- ':!docs' |");
open(L, "git log --reverse --pretty=fuller --date=short --stat -- src lib include |");
#open(L, "git log --reverse --pretty=fuller --date=short --stat -- ':!docs' |");
#open(L, "git log --reverse --pretty=fuller --date=short --stat -- tests |");

# map commit hashes to release tags
sub commit2release {
    open(T, "git for-each-ref refs/tags/*|");
    # 329bcf3a7117c7e5c26d7c8f840af64fb7140753 commit refs/tags/curl-7_9_1
    while(<T>) {
 #       print "IN $_";
        if($_ =~ /^([0-9a-f]+) (commit|tag)[ \t]+refs\/tags\/(curl-[0-9_]*)$/) {
            my ($hash, $type, $version)=($1, $2, $3);

            # if it is a tag, we must find the commit
            my $actual = `git rev-list -n 1 $hash`;
            chomp $actual;
            if($actual ne $hash) {
                print "$hash $type => $actual\n";
                $hash = $actual;
            }

            # convert to plain version number
            $version =~ s/curl-//;
            $version =~ s/_/./g;
            $commit{$hash} = $version;
#            print "$hash is $version\n";
        }
    }
    close(T);
}

#commit2release();

my $date;
my $lines;
my $c;
my $release;
my $hash;
while(<L>) {
    chomp;
    my $line = $_;
    if($line =~ /^CommitDate:([ \t]*)(.*)/) {
        $date = $2;
    }
    elsif($line =~ /^commit ([0-9a-f]+)$/) {
        $hash = $1;
    }
    elsif($line =~ /^ (\d*) file(|s) changed, (.*)/) {
        my $d=$3;
        my $adds=0;
        my $dels=0;

        $d =~ s/, //; #remove comma
        if($d =~ s/(\d*) insertion(s|)\(\+\)//) {
            $adds = $1;
        }
        if($d =~ s/(\d*) deletion(s|)\(\-\)//) {
            $dels = $1;
        }
        $lines += $adds;
        $lines -= $dels;


        if($date =~ /^(\d\d\d\d)-(\d\d)/) {
            $month = "$1-$2";
            $sdate = "$date";
        }

        #if($month < "2010-01") {
        #    next;
        #}

        # new date
        if($sdate ne $ldate) {
            my $contains = `git describe --contains $hash --exact-match --match "curl*" --exclude '*[^0-9]' 2>/dev/null`;
            chomp $contains;
            if($contains =~ /curl-([0-9_]*)(~|$)/) {
                $version = $1;
                $version =~ s/curl-//;
                $version =~ s/_/./g;
                $release = $version;
            }
            else {
                $release ="";
            }

            print "$date;$lines;$release\n";
            $ldate = $sdate;
            $lrelease = $release
        }
        $c++;
        $date="";
    }
}
